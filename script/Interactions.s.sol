// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";


contract FundFundMe is Script {

    uint256 constant SEND_VALUE = 0.01 ether;
    address USER = makeAddr("user");

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }

    function fundFundMe(address _mostRecentlyDeployed) public {
        FundMe fundMeContract = FundMe(payable(_mostRecentlyDeployed));
        vm.deal(USER,SEND_VALUE);
        vm.prank(USER);
        fundMeContract.fund{value: SEND_VALUE}();
        console.log("Funded FundMe with %s",SEND_VALUE);
    }

}

contract WithdrawFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;
    address USER = makeAddr("user");

    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s",SEND_VALUE);
    }
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        vm.prank(USER);
        withdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}