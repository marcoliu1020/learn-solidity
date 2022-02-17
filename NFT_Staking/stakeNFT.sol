// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract stakNFT {

    uint256 private stakingID;
    uint256 public stakingRate;

    // NFT list
    struct NftInfo {
        uint256 tokenID;
        address staker;
        uint256 stakeAt; // staking time
    }
    mapping(uint256 => NftInfo) public nftList;

    // Mapping from owner address to token points 
    mapping(address => uint256) private _tokenBalance;

    constructor() {
        stakingRate = 1;
    }


    /**
     * 質押 NFT
     * 輸入 `_tokenID`
     */
    function stake(uint256 _tokenID) external {
        nftList[stakingID] = (
            NftInfo({
                tokenID: _tokenID,       // the ID in NFT contract
                staker: msg.sender,      // staker
                stakeAt: block.timestamp // staking time
            })
        );

        stakingID++; // the ID in staking list
    }

    /**
     * 贖回 NFT
     * 輸入 `_stakeID`
     */
    function unStake(uint256 _stakeID) external {
        require(nftList[_stakeID].staker == msg.sender, "not owner");

        _tokenBalance[msg.sender] += _processReward(_stakeID, block.timestamp);
        delete nftList[_stakeID];
    }

    /**
     * 質押者資訊
     * `stakingAmount` : 質押數量
     * `stakeIDs` : `nftList` 裡面的 index
     * `stakingReward` : 正在質押中的獎勵，持續跳動
     */
    function getStakerInfo(address _staker) view external 
        returns (
            uint256 stakingAmount, 
            uint256[] memory stakeIDs,
            uint256 stakingReward,
            uint256 tokenBalance
        ) 
    {
        (stakingAmount, stakeIDs) = _getStakingIDs(_staker);

        // staking rewards is increasing
        stakingReward = _getStakingReward(stakingAmount, stakeIDs);
        // tokens
        tokenBalance = _tokenBalance[_staker];
    }

    /**
     * 所有 NFT 正在質押的數量
     */
    function getNftStakingAmount() view external 
        returns (uint256 amount) 
    {
        for (uint256 i=0; i < stakingID; i++)
            if (nftList[i].staker != address(0))
                amount++;
    }

    /**
     * 提領代幣
     */
    function withdraw(uint256 _amount) external {
        require(_amount <= _tokenBalance[msg.sender], "token not enough!");
        _tokenBalance[msg.sender] -= _amount;
    }



    /**
     * `_staker` 正在質押的數量
     */
    function _getStakingIDs(address _staker) view internal 
        returns (uint256 amount, uint256[] memory ids) 
    {
        // get amount
        for (uint256 id = 0; id < stakingID; id++)
            if (nftList[id].staker == _staker)
                amount++;

        // get ids
        uint256 num;
        ids = new uint256[](amount); // fixed dynamic array
        for (uint256 id = 0; id < stakingID; id++)
            if (nftList[id].staker == _staker)
                ids[num++] = id;

    }
    
    /**
     * 計算獎勵
     */
    function _calculateRewards(uint256 _timeElapsed) view internal 
        returns (uint256) 
    {
        return _timeElapsed * stakingRate;
    }

    function _processReward(uint256 _stakeID, uint256 _nowTime) view internal 
        returns (uint256) 
    {
        return _calculateRewards(_nowTime - nftList[_stakeID].stakeAt);
    }

    /**
     * `_staker` 正在質押的獎勵
     */
    function _getStakingReward(uint256 _amount, uint256[] memory _stakeIDs) view internal 
        returns (uint256 reward) 
    {
        for (uint256 i = 0; i < _amount; i++) 
            reward += _processReward(_stakeIDs[i], block.timestamp);
    }

}