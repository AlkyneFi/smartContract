// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract AlkyneWallet is Ownable, ReentrancyGuard{
    uint256 public fundedBalance;
    mapping(address => uint256) public followers;
    address[] public followersArray;
    uint256 MULTIPLIER = 100000;


    function trade(uint256 quantityToSell, address sourceToken,
    address destinantionToken) public {
        uint256 amountOwned = IERC20(sourceToken).balanceOf(address(this));
        uint256 portfolioPercentage = (quantityToSell * MULTIPLIER) / amountOwned;
        
        //TODO: trading function



        for (uint256 i = 0; i < followersArray.length; i++) {
            address follower = followersArray[i];
            uint256 followerBalance = followers[follower];

            if (followerBalance > portfolioPercentage) {
                AlkyneWallet(follower).replicateTrade(portfolioPercentage, sourceToken, destinantionToken);
            }
        }
    }

    function replicateTrade(uint256 portfolioPercentage, address sourceToken,
    address destinantionToken) public nonReentrant {
        uint256 amountOwned = IERC20(sourceToken).balanceOf(address(this));
        uint256 quantityToSell = (amountOwned * portfolioPercentage) / MULTIPLIER;

        trade(quantityToSell, sourceToken, destinantionToken);
    }

    function sell(uint256 quantityToSell, address sourceToken) public {
        uint256 amountOwned = IERC20(sourceToken).balanceOf(address(this));
        uint256 portfolioPercentage = (quantityToSell * MULTIPLIER) / amountOwned;
        
        //TODO: selling function



        for (uint256 i = 0; i < followersArray.length; i++) {
            address follower = followersArray[i];
            uint256 followerBalance = followers[follower];

            if (followerBalance > portfolioPercentage) {
                AlkyneWallet(follower).replicateSell(portfolioPercentage, sourceToken);
            }
        }        
    }

    function replicateSell(uint256 portfolioPercentage, address sourceToken
     ) public nonReentrant {
        uint256 amountOwned = IERC20(sourceToken).balanceOf(address(this));
        uint256 quantityToSell = (amountOwned * portfolioPercentage) / MULTIPLIER;

        sell(quantityToSell, sourceToken);
    }    

    function withdraw(uint256 amount) public onlyOwner {
        payable(owner()).transfer(amount);
        if (fundedBalance > amount) {
            fundedBalance -= amount;
        } else {
            fundedBalance = 0;
        }
    }

    function deposit() public payable onlyOwner{
        fundedBalance += msg.value;
    }

    function addFollower(address follower, uint256 amount) external {
        if (followers[follower] == 0) {
            followersArray.push(follower);
        }
        followers[follower] += amount;
        if (followers[follower] > MULTIPLIER)
            followers[follower] = MULTIPLIER;
    }

}
