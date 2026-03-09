// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    AggregatorV3Interface internal sPriceFeed;
    address private immutable OWNER;
    mapping(address => uint256) private sContribuitors;

    uint256 constant MINIMUM_DOLLARS = 5e18;

    function fund() public payable isEnough {
        sContribuitors[msg.sender] += msg.value;
    }

    function withdraw() public isOwner {
        (bool callSucess, ) = payable(OWNER).call{value: address(this).balance}(
            ""
        );
        require(callSucess, "Call failed");
    }

    receive() external payable {
        fund();
    }

    constructor(address priceFeed) {
        OWNER = msg.sender;
        sPriceFeed = AggregatorV3Interface(priceFeed);
    }

    function getEthPrice() public view returns (uint256) {
        int256 ethInDollar;
        (, ethInDollar, , , ) = sPriceFeed.latestRoundData();
        return uint(ethInDollar);
    }

    modifier isEnough() {
        int256 ethInDollar;
        (, ethInDollar, , , ) = sPriceFeed.latestRoundData();
        require(
            (msg.value * (uint(ethInDollar) * 1e10)) / 1e18 >= MINIMUM_DOLLARS
        );
        _;
    }

    modifier isOwner() {
        require(msg.sender == OWNER, "Only the owner can withdraw the balance");
        _;
    }

    function getContributionFromAddress(
        address target
    ) external view returns (uint256) {
        return sContribuitors[target];
    }

    function getOwner() external view returns (address) {
        return OWNER;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
