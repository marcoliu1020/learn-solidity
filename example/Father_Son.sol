//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";


/**
    deploy Father(0xd9145CCE52D386f254917e481eB44e9943F39138)
    deploy Son   (0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8)

    0x5B38... : Father.whoCallFather()
    console.log:
    0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 call Father

    0x5B38... : Son.whoCallSon()
    console.log:
    0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 call Son
    0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8 call Father (Son call Father)
 */


contract Father {
    function whoCallFather() view public {
        console.log(msg.sender, "call Father");
    }
}

interface IFather {
    function whoCallFather() view external;
}

contract Son {
    IFather public father;

    constructor(IFather _address) {
        father = _address;
    }

    function whoCallSon() view public {
        console.log(msg.sender, "call Son");
        father.whoCallFather();
    }
}