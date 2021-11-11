pragma solidity 0.8.9;

import "./IVoteD21.sol";

contract D21 is IVoteD21 {
    address private _owner; 
    uint256 _deployemtTime;
    
    mapping (address => Subject) private _addToSubject;
    address[] private _subjectsAddrs;
    mapping (address => int) _votingStatus;
    mapping (address => address) _firstVoteSubject;
    mapping (address => bool) _isVoter;
    mapping (address => bool) _hasRegistered;
    mapping(address => bool) _isSubjectAdd;
    
    function getRemainingTime() external view returns (uint)
    {
       return (_deployemtTime + 1 weeks) - block.timestamp; 
    }
    
    modifier isLessThanWeek()
    {
        require((_deployemtTime + 1 weeks) - block.timestamp > 0);
        _;
    }
    constructor() {
        // set owner to the address which deploys the contract 
        _owner = msg.sender; 
        _deployemtTime = block.timestamp;
    }
        
    function addSubject(string memory name) isLessThanWeek external
    {
        require(!_hasRegistered[msg.sender], "You have already registered a party");
        _hasRegistered[msg.sender] = true;
       _addToSubject[msg.sender] = Subject(name, 0);
       _subjectsAddrs.push(msg.sender);
       _isSubjectAdd[msg.sender] = true;
    }
    function addVoter(address addr) isLessThanWeek external
    {
        require(_owner == msg.sender && !_isVoter[addr], "Only owner is allowed to add voters");
        _votingStatus[addr] = 0;
       _isVoter[addr] = true;
    }
    
    function getSubjects() external view returns (address[] memory)
    {
        return _subjectsAddrs;
    } 
    
    function getSubject(address addr) external view returns (Subject memory)
    {
        return _addToSubject[addr];
    }

    function votePositive(address addr) isLessThanWeek external
    {
            
         require(_votingStatus[msg.sender] < 2, "You casted all your positive votes");   
         require(_firstVoteSubject[msg.sender] != addr, "You cannot vote for the same party twice");   
         require(_isVoter[msg.sender], "You are not allowed to vote");  
         require(_isSubjectAdd[addr], "The specdified address is not a party");
         _addToSubject[addr].votes++;
         _votingStatus[msg.sender]++;
         _firstVoteSubject[msg.sender] = addr;
    }
    function voteNegative(address addr) isLessThanWeek external
    {
       
        require(_votingStatus[msg.sender] == 2, "Not all positive votes casted");    
        require(_isSubjectAdd[addr], "The specdified address is not a party");
         _addToSubject[addr].votes--;
         _votingStatus[msg.sender]++;
        
    }
    

}
