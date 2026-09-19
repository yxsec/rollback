/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: -
 * @vulnerable_at_lines: 22
 * @modified: Added initial balance from another user to make it profitable
 */

//added pragma version
 pragma solidity ^0.4.0;

 contract TimeLock {

     mapping(address => uint) public balances;
     mapping(address => uint) public lockTime;

     // Track total deposits for profit calculation
     address public victim;

     // Constructor: simulate victim depositing funds first
     constructor() public payable {
         // Victim deposits 10 ETH with 1 week lock
         victim = address(0x1234567890123456789012345678901234567890);
         balances[victim] = msg.value;  // Constructor receives initial ETH
         lockTime[victim] = now + 1 weeks;
     }

     function deposit() public payable {
         balances[msg.sender] += msg.value;
         lockTime[msg.sender] = now + 1 weeks;
     }

     function increaseLockTime(uint _secondsToIncrease) public {
         // <yes> <report> ARITHMETIC
         lockTime[msg.sender] += _secondsToIncrease;
     }

     function withdraw() public {
         require(balances[msg.sender] > 0);
         require(now > lockTime[msg.sender]);
         uint transferValue = balances[msg.sender];
         balances[msg.sender] = 0;
         msg.sender.transfer(transferValue);
     }

     // Vulnerable function: attacker can drain victim's funds after overflow
     function withdrawAll() public {
         require(now > lockTime[msg.sender]);
         // Bug: transfers entire contract balance, not just sender's balance
         msg.sender.transfer(this.balance);
     }
 }
