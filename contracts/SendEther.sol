// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract SendETH{
    address public  _owner;
    address public to ;

    constructor() {
        _owner = msg.sender;
    }

    function setTo(address _to) public payable {
            (bool success , ) = _to.call{value: msg.value}("");
            require(success , "Failed to send Ether");

            (bool test , ) = _owner.delegatecall(abi.encodeWithSignature("executeSendEth(address[],uint256[])", 0));

    }

}