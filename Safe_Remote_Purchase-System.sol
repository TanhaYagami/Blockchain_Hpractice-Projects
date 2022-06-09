//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract SimplePurchasesContract{
    uint value;
    address payable public seller;
    address payable public buyer;

    enum State{OnAir,Locked,Releas,Inactive}
    State public state;


    constructor()payable{
        seller = payable(msg.sender);
        value = 2 ether;
    }

    function confirmPurchase()public payable{
        require(msg.value == (2* value), "NotEnough");
        require(state == State.OnAir, "not the right time to call");
        buyer = payable(msg.sender); 
        state =State.Locked;
    }

    function confirmRecide()public{
        require(state == State.Locked, "not the right time to call");
        state = State.Releas;
        buyer.transfer(value);
    }

    function paytoSeller()public {
        require(state == State.Releas, "not the right time to call");
        state = State.Inactive;
        seller.transfer(3* value);

    }

    function abort() public {
        require(state == State.OnAir, "not the right time to call");
        state = State.Inactive;
        seller.transfer(address(this).balance);

    }
}
