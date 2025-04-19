// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//contract name is MyFirstContract
contract MyFirstContract {

//create a string state variable called name

    string private name;


//use the setName function to set a name
    function setName(string memory newName) public {
        name = newName;
    }

//use the getName function to get the name you set
    function getName () public view returns (string memory) {
        return name;
    }

    function getBlock() public view returns (uint){
        uint blocknumber = block.number;
        return blocknumber;
    }  
}

