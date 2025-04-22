// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract Willcontract{
    address private owner;
    address private recipent;
    uint256 private TimeStamp;


    constructor(){
        owner = msg.sender;
        recipent = msg.sender;
        TimeStamp = block.timestamp;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You must be the contract owner.");
        _;
    }

    modifier allowRecipent(){
        require(block.timestamp > TimeStamp + 365 days , "The contract can send messages after 365 days");
        _;
    }

    function changeRecipent(address _recipent) public  onlyOwner(){
        
        recipent = _recipent;

    }
    function ping()public onlyOwner{
        TimeStamp = block.timestamp;
    }

    function withdraw() public view allowRecipent returns (uint){
        return 100;
    }

}