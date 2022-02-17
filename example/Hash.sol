// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract IntToBytes_StringToBytes {

    function intToBytes(uint x, uint y) pure public 
        returns (bytes memory) 
    {
        /**
         * abi.encodePacked return n * 32 bytes
         * int -> hex
         * x = 10 -> a
         * y = 15 -> f
         *  0x000000000000000000000000000000000000000000000000000000000000000a
         *    000000000000000000000000000000000000000000000000000000000000000f
        */
        return abi.encodePacked(x, y);
    }

    function stringToBytes(string memory x) pure public 
        returns (string memory utf8Data, bytes memory bytesData) 
    {
        // string: Dynamically-sized UTF-8-encoded string

        /**
         * x = 劉
         */
        utf8Data = x;         // >>> 劉
        bytesData = bytes(x); // >>> 0xe58a89
    }

    function kk(uint x) pure public 
        returns (bytes32)
    {
        // keccak256(bytes memory) returns (bytes32)

        // x = 10
        // abi.encodePacked(x)
        // >>> '0x000000000000000000000000000000000000000000000000000000000000000a'
        // keccak256(abi.encodePacked(x))
        // >>> '0xc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a8'
        return keccak256(abi.encodePacked(x));

        // ethers keccak256
        // hex32 = ethers.utils.hexZeroPad(10, 32)
        // >>> '0x000000000000000000000000000000000000000000000000000000000000000a'
        // ethers.utils.keccak256(hex32)
        // >>> '0xc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a8'

        // solidity keccak256
        // ethers.utils.solidityKeccak256(['int'], ['10']) // '10' 不用字串也可以
        // >>> '0xc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a8'
    }
}