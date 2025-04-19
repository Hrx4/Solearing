// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Mod{
    address public owner;
    bool public paused;
    mapping (address => uint) public balance; 

    constructor() {
        owner = msg.sender;
        paused = false;
        balance[owner] = 100;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You must be the contract owner.");
        _;
    }

    modifier checkPause(){
        require(paused==false , "This contract is  paused!");
        _;
    }

    function pause() public onlyOwner{
        paused=true;
    }
    function unpause() public onlyOwner{
        paused=false;
    }

    function transfer(address to , uint amount) public checkPause {
        require(balance[owner]>=amount, "Not enough balance.");
        balance[msg.sender] -= amount;
        balance[to] += amount;
    }

}
