pragma solidity ^0.4.25;

contract GaslessSendVault {
    mapping (address => uint) public balances;
    address public owner;
    uint public totalDeposits;

    constructor() public payable {
        owner = msg.sender;
        // Contract starts with some ETH (simulates existing deposits)
        totalDeposits = msg.value;
    }

    // Vulnerable: Anyone with ANY balance can become owner
    function takeOver() public {
        if (balances[msg.sender] > 0) {
            owner = msg.sender;
        }
    }

    function deposit() public payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        totalDeposits += msg.value;
    }

    function() public payable {
        deposit();
    }

    // <yes> <report> UNCHECKED_LL_CALLS
    // Vulnerable: Owner can drain entire contract balance to any address
    function drainTo(address recipient) public {
        require(msg.sender == owner, "Not owner");
        uint amount = address(this).balance;
        require(amount > 0, "No balance");
        // Gasless send - return value not checked
        recipient.send(amount);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
