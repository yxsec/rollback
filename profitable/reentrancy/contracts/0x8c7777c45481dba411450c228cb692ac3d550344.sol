/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 41
 */
 
pragma solidity ^0.4.19;

contract ETH_VAULT
{
    struct VaultAccount {
        uint deposited;
        uint lastAction;
    }

    mapping (address => VaultAccount) public accounts;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
    function ETH_VAULT(address _log)
    public 
    {
        TransferLog = Log(_log);
    }
    
    function Deposit()
    public
    payable
    {
        if(msg.value > MinDeposit)
        {
            accounts[msg.sender].deposited += msg.value;
            accounts[msg.sender].lastAction = now;
            TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
        }
    }
    
    function CashOut(uint _am)
    public
    payable
    {
        uint stored = accounts[msg.sender].deposited;
        if (_am <= stored)
        {
            // <yes> <report> REENTRANCY
            bool completed = msg.sender.call.value(_am)();
            if(completed)
            {
                // The callback runs while the old deposited amount is visible.
                accounts[msg.sender].deposited = stored - _am;
                accounts[msg.sender].lastAction = now;
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
