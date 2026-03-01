//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployerFundMe} from "../script/DeployerFundMe.s.sol";

contract FundMeTest is Test {
    DeployerFundMe deployerFundMe = new DeployerFundMe();
    FundMe fundMe;
    address user_test = makeAddr("user_test"); // Creates a third user for testing
    uint256 constant SEND_VALUE = 2960419195358063; //Minimum ETH that corresponds to 5 USD
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        fundMe = deployerFundMe.run();
        vm.deal(user_test, 10 ether); //Give the test user some start balance
    }

    function testDemo() public {}

    function testSendingEnough() public funded {}

    function testSendingNotEnough() public {
        //Arrange
        vm.prank(user_test);
        //Act & Assert
        vm.expectRevert();
        fundMe.fund();
    }

    function testingReceive() public {
        //Arrange
        vm.prank(user_test);
        //Act
        (bool callSucess, ) = payable(user_test).call{value: SEND_VALUE}("");
        //Assert
        assertEq(callSucess, true);
    }

    function testContribuitorsList() public funded {
        //Assert
        assertEq(fundMe.getContributionFromAddress(user_test), SEND_VALUE);
    }

    function testWithdrawNotOwner() public funded {
        //Assert
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawOwner() public {
        //Arrange
        address OWNER = fundMe.getOwner();
        uint256 INITIAL_OWNER_BALANCE = fundMe.getOwner().balance;
        uint256 INITIAL_CONTRACT_BALANCE = address(fundMe).balance;
        vm.prank(OWNER);
        //Act
        uint256 startingGas = gasleft();
        vm.txGasPrice(GAS_PRICE);
        fundMe.withdraw();
        uint256 endingGas = gasleft();
        console.log("Gas used to withdraw: ");
        console.log((startingGas - endingGas) * tx.gasprice);
        //Assert
        assertEq(
            OWNER.balance,
            INITIAL_OWNER_BALANCE + INITIAL_CONTRACT_BALANCE
        );
    }

    modifier funded() {
        vm.prank(user_test);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }
}
