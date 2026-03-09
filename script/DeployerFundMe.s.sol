//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployerFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address ethPriceFeed = helperConfig.activeNetworkcConfig(); //Coloquei essa variavel aqui pra não rodar a função enquanto dou deploy no contrato
        //Assim economizando gas
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
