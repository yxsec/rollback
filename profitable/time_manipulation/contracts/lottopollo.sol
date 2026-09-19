/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/timestampdependent.sol
 * @author: -
 * @vulnerable_at_lines: 13,27
 * @modified: Fixed logic bug - now uses stored timestamp instead of current rand
 */

pragma solidity ^0.4.0;
contract lottopollo {
  address leader;
  uint    public timestamp;

  // Constructor: initialize with some funds
  constructor() public payable {
      leader = msg.sender;
      timestamp = now;  // Initial timestamp
  }

  function payOut(uint rand) internal {
    // <yes> <report> TIME MANIPULATION
    // Fixed: compare with stored timestamp, not current rand
    if ( timestamp > 0 && now - timestamp > 24 hours ) {
      msg.sender.send( msg.value );

      if ( this.balance > 0 ) {
        leader.send( this.balance );
      }
    }
    else if ( msg.value >= 1 ether ) {
      leader = msg.sender;
      timestamp = now;  // Store current time for next check
    }
  }
  function randomGen() constant returns (uint randomNumber) {
      // <yes> <report> TIME MANIPULATION
      return block.timestamp;
    }
  function draw(uint seed) public payable {
    uint randomNumber=randomGen();
    payOut(randomNumber);
  }

  // Direct withdraw for attacker who is leader
  function claimAsLeader() public {
      require(msg.sender == leader);
      require(now - timestamp > 24 hours);
      msg.sender.transfer(this.balance);
  }
}
