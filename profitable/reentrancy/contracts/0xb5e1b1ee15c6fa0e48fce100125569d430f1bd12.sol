/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 40
 */

pragma solidity ^0.4.19;

contract Private_Bank
{
    mapping (address => uint) public credit;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function Private_Bank(address _log)
    {
        TransferLog = Log(_log);
    }
    
    function Deposit()
    public
    payable
    {
        if(msg.value > MinDeposit)
        {
            credit[msg.sender] = credit[msg.sender] + msg.value;
            TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
        }
    }
    
    function CashOut(uint _am)
    public
    payable
    {
        uint available = credit[msg.sender];
        if (_am <= available)
        {
            // <yes> <report> REENTRANCY
            bool sent = msg.sender.call.value(_am)();
            if(sent)
            {
                // State is updated only after the external callback.
                credit[msg.sender] = available - _am;
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
