/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 38
 */

pragma solidity ^0.4.19;

contract PrivateBank
{
    struct Account {
        uint deposited;
        uint withdrawals;
    }

    mapping (address => Account) public accounts;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function PrivateBank(address _log)
    {
        TransferLog = Log(_log);
    }
    
    function Deposit()
    public
    payable
    {
        if(msg.value >= MinDeposit)
        {
            accounts[msg.sender].deposited += msg.value;
            TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
        }
    }
    
    function CashOut(uint _am)
    {
        uint available = accounts[msg.sender].deposited;
        if (_am <= available)
        {            
            // <yes> <report> REENTRANCY
            bool success = msg.sender.call.value(_am)();
            if(success)
            {
                // The account is changed only after the external call.
                accounts[msg.sender].deposited = available - _am;
                accounts[msg.sender].withdrawals += _am;
                TransferLog.AddMessage(msg.sender,_am,"CashOut");
            }
        }
    }
    
    function() public payable{}    
    
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
