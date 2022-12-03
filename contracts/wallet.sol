// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract AlkyneWallet is Ownable {
    uint256 public fundedBalance;
    mapping(address => uint256) public followers;
    const MULTIPLIER = 100000;


    function trade(uint256 portfolioPercentage) public onlyOwner nonReentrant {
        // trading function

        
    }

    function withdraw(uint256 amount) public onlyOwner {
        owner().transfer(amount);
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
        followers[follower] += amount;
        if (followers[follower] > MULTIPLIER)
            followers[follower] = MULTIPLIER;
    }

}