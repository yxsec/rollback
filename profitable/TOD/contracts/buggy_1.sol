/*
 * @source: Historical TOD benchmark fixture, reduced to one mechanism.
 * @vulnerable_at_lines: 25, 34
 */

pragma solidity ^0.5.11;

// A single-purpose transaction-order-dependent reward contract.
contract TODVulnerable {
    address payable public owner;
    bool public claimed;
    uint256 public reward;

    constructor() public {
        owner = msg.sender;
    }

    function setReward() public payable {
        require(!claimed);
        require(msg.sender == owner);
        owner.transfer(reward);
        reward = msg.value;
    }

    function claimReward(uint256 submission) public {
        require(!claimed);
        require(submission < 10);
        msg.sender.transfer(reward);
        claimed = true;
    }
}
