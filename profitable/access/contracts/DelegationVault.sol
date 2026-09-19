// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DelegationVault {
    address public owner;
    uint256 public totalDeposits;
    bool public initialized;

    constructor() payable {
        owner = msg.sender;
        initialized = true;
        totalDeposits = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // <yes> <report> ACCESS_CONTROL
    // Vulnerable: Anyone can call pwn() to become owner if not initialized
    // (Simulates delegatecall vulnerability where attacker can overwrite owner)
    function pwn() public {
        // Bug: should check `initialized` but doesn't!
        owner = msg.sender;
    }

    receive() external payable {
        totalDeposits += msg.value;
    }

    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        totalDeposits += msg.value;
    }

    // Only owner can withdraw - but attacker can become owner via pwn()!
    function withdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "No balance");
        payable(msg.sender).transfer(amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
