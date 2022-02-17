// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl{

    // role  => account => bool
    // admin => Alice   => true
    mapping (bytes32 => mapping(address => bool)) public roles;

    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));
    // 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96

    event GrandRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    // 帳號權限
    // roles[ADMIN][address] = true || false
    // roles[USE][address]   = true || false
    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    constructor() {
        // 先把 "合約部屬的人" 設為 "管理者"
        _grandRole(ADMIN, msg.sender);
    }

    function _grandRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrandRole(_role, _account);
    }

    // 只有 "管理者" 才能開權限
    function grandRole(bytes32 _role, address _account) external onlyRole(ADMIN) {
        _grandRole(_role, _account);
    }

    // 只有 "管理者" 才能關權限
    function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN) {
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }

}