//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Vault {
    // 2 ** 256 slot

    // slot 0
    uint256 public count = 123; // 32 bytes
    // slot 1
    address public owner = msg.sender; // 20 bytes
    bool public isTrue = true; // 1 byte
    uint16 public u16 = 31; // 2 bytes
    // slot 2
    bytes32 private password; // 0x0

    // constant do not use storage
    uint256 public constant someConst = 321;

    // slot 3, 4, 5
    bytes32[3] public data;

    struct User {
        uint256 id;
        bytes32 password;
    }

    // slot 6 - length of array
    // starting from slot keccak256(6) - array elements
    // slot where element is stored = keccak256(slot) + (index * elementSize)
    // where slot = 6 and elementSize = 2 (1 uint + 1 bytes32)
    User[] private users;

    // slot 7 - empty
    // entries are stored at keccak256(key, slot)
    // where slot = 7, key = map key
    mapping(uint256 => User) private idToUser;

    constructor(bytes32 _password) {
        password = _password;
    }

    function addUser(bytes32 _password) public {
        User memory user = User({id: users.length, password: _password});

        users.push(user);
        idToUser[user.id] = user;
    }

    function getArrayLocation(
        uint256 slot,
        uint256 index,
        uint256 elementSize
    ) public pure returns (uint256) {
        return
            uint256(keccak256(abi.encodePacked(slot))) + (index + elementSize);
    }

    function getMapLocation(uint256 slot, uint256 key)
        public
        pure
        returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(key, slot)));
    }
}
