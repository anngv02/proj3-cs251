// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise {
// DO NOT MODIFY ABOVE THIS

// ADD YOUR CONTRACT CODE BELOW
    mapping(address => mapping(address => uint32)) public debts;
    mapping(address => uint256) public lastActive;
    address[] public users;
    mapping(address => bool) public isUser;

    event IOUAdded(address indexed debtor, address indexed creditor, uint32 amount);

    function lookup(address debtor, address creditor) public view returns (uint32) {
        return debts[debtor][creditor];  // Nếu chưa có khoản nợ, mặc định là 0
    }

    function add_IOU(address creditor, uint32 amount) public {
        require(amount > 0, "Amount must be positive");
        require(msg.sender != creditor, "You cannot owe yourself");

        // Cập nhật nợ
        debts[msg.sender][creditor] += amount;

        // Cập nhật thời gian hoạt động
        lastActive[msg.sender] = block.timestamp;
        lastActive[creditor] = block.timestamp;

        // Thêm người dùng mới vào danh sách nếu chưa có
        if (!isUser[msg.sender]) {
            users.push(msg.sender);
            isUser[msg.sender] = true;
        }
        if (!isUser[creditor]) {
            users.push(creditor);
            isUser[creditor] = true;
        }

        emit IOUAdded(msg.sender, creditor, amount);
    }

    function getTotalOwed(address user) public view returns (uint32 total) {
        for (uint i = 0; i < users.length; i++) {
            total += debts[user][users[i]];
        }
    }

    function getUsers() public view returns (address[] memory) {
        return users;
    }

    function getLastActive(address user) public view returns (uint256) {
        return lastActive[user];
    }

}
