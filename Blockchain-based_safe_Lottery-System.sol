//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LotterySystem{
    address public Owner;
    address payable[] public players;
    uint public LotteryId;
    mapping (uint => address payable) public LotteryWinner;

    constructor(){
        Owner= msg.sender;
    }
    modifier OnlyForOwner{
        require(msg.sender == Owner, "Only Owner can perform this Action");
        _;
    }

    function getWinner() public view OnlyForOwner returns(address payable){
        return LotteryWinner[LotteryId];
    }


    function enterLottery() public payable{
        require(msg.value == 1 ether, "You must buy the Lottery with Efficiant amount");
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view OnlyForOwner returns(uint){
        return uint(keccak256(abi.encodePacked(Owner, block.timestamp)));
    }

    function setWinner() public OnlyForOwner{
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance); 
        LotteryWinner[LotteryId] = players[index];

        LotteryId++;

        players= new address payable[](0);
    }

    function getPotBalance()public view OnlyForOwner returns(uint){
        return address(this).balance;
    }

    function getPlayer()public view OnlyForOwner returns(address payable[] memory){
        return players;
    }
    
}

