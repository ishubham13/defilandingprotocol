// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DefiLendingProtocol {
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public loans;

    uint256 public totalDeposits;
    uint256 public interestRate = 5; // 5% interest rate

    // Deposit funds to the protocol
    function deposit() external payable {
        require(msg.value > 0, "Must deposit positive amount");
        deposits[msg.sender] += msg.value;
        totalDeposits += msg.value;
    }

    // Borrow funds from the protocol
    function borrow(uint256 amount) external {
        require(amount <= totalDeposits, "Insufficient funds in protocol");
        loans[msg.sender] += amount;
        totalDeposits -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Repay borrowed funds with interest
    function repay() external payable {
        require(loans[msg.sender] > 0, "No outstanding loan");
        uint256 owed = loans[msg.sender] + (loans[msg.sender] * interestRate / 100);
        require(msg.value >= owed, "Not enough to repay loan plus interest");
        loans[msg.sender] = 0;
        totalDeposits += msg.value;
    }

    // Check user's deposited balance
    function getDepositBalance(address user) external view returns (uint256) {
        return deposits[user];
    }
}
