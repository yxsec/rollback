// SPDX-License-Identifier: MIT
/*
 * @source: https://blog.solidityscan.com/security-issues-with-delegate-calls-4ae64d775b76
 * @author: 
 * @vulnerable_at_lines: 35
 */

pragma solidity ^0.8.0;

contract Delegate {

    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {

    address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) payable {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    receive() external payable {}

    fallback() external {
        // <yes> <report> unsafe delegatecall
        (bool result,) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }

    function withdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "No balance");
        payable(msg.sender).transfer(amount);
    }

    // Atomic economic witness for the delegatecall storage overwrite.
    function claim() external {
        (bool result,) = address(delegate).delegatecall(
            abi.encodeWithSignature("pwn()")
        );
        require(result, "delegatecall failed");
        uint256 amount = address(this).balance;
        require(amount > 0, "No balance");
        payable(msg.sender).transfer(amount);
    }
}
