// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract memoryMapVsArray {

    struct User {
        uint id;
        string password;
    }
    User[] public users;

    mapping(uint => User) public idToUser;

    constructor() {
        addUser("Hi");
        addUser("Marco");
        addUser("GOGO!");
    }

    function addUser(string memory _password) public {
        User memory user = User({
            id: users.length,
            password: _password
        });

        users.push(user);
        idToUser[user.id] = user; // 另外 mapping 一個位置
    }

    function changePassword(uint _id, string memory _password) public {
        // User[] public users 裡的 user 和 idToUser[_id] 是不同的
        User storage user = idToUser[_id];
        user.password = _password;
    }
}   