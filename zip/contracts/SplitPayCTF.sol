 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SplitPayCTF {
    address public organizer;
    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor() {
        organizer = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance");

        // 漏洞：先转账，后更新余额，存在重入风险
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        balances[msg.sender] = 0;
        emit Withdraw(msg.sender, amount);
    }

    function isSolved() external view returns (string memory) {
        if (address(this).balance == 0) {
            return "flag{aa_pay_reentrancy_hacked}";
        }
        return "not solved";
    }

    receive() external payable {}
}