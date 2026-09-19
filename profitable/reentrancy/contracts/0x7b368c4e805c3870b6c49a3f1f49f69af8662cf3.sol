/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 29
 */

pragma solidity ^0.4.25;

contract W_WALLET
{
    struct WalletState
    {
        uint balance;
        uint unlockTime;
    }

    mapping (address => WalletState) public wallets;

    function Put(uint _unlockTime)
    public
    payable
    {
        WalletState storage acc = wallets[msg.sender];
        acc.balance = acc.balance + msg.value;
        if (_unlockTime > now) {
            acc.unlockTime = _unlockTime;
        } else {
            acc.unlockTime = now;
        }
        LogFile.AddMessage(msg.sender,msg.value,"Put");
    }

    function Collect(uint _am)
    public
    payable
    {
        WalletState storage acc = wallets[msg.sender];
        bool eligible = acc.balance >= MinSum &&
                        acc.balance >= _am &&
                        now > acc.unlockTime;
        if (eligible)
        {
            // <yes> <report> REENTRANCY
            if(msg.sender.call.value(_am)())
            {
                // The balance is intentionally reduced after the callback.
                acc.balance = acc.balance - _am;
                LogFile.AddMessage(msg.sender,_am,"Collect");
            }
        }
    }

    function() 
    public 
    payable
    {
        Put(now);
    }

    Log LogFile;

    uint public MinSum = 1 ether;    

    function W_WALLET(address log) public{
        LogFile = Log(log);
    }
}


contract Log 
{
    struct Message
    {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }

    Message[] public History;

    Message LastMsg;

    function AddMessage(address _adr,uint _val,string _data)
    public
    {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}
