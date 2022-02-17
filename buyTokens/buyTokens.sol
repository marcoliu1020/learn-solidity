// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract useToken is Ownable {
    IERC20 public token;

    address payable public wallet;
    uint256 public tokenPrice = 0.05 ether;

    constructor(IERC20 _token, address payable _wallet) {
        // token Address of the token being sold
        token = _token;
        // wallet Address where collected funds will be forwarded to
        wallet = _wallet;
    }

    function setTokenPrice(uint256 _tokenPrice) external onlyOwner {
        tokenPrice = _tokenPrice;
    }

    function buyToken(address beneficiary, uint256 _amountTokens) external payable {
        require(_amountTokens * tokenPrice <= msg.value, "Not enough ether sent");

        // transfer tokens to beneficiary from this contract's balance
        token.transfer(beneficiary, _amountTokens);  

        // transfer wei to wallet
        wallet.transfer(msg.value);
    }
}