// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./AlkyneWallet.sol";
import "https://github.com/lens-protocol/core/blob/main/contracts/interfaces/ILensHub.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./AlkyneToken.sol";

contract Orchestrator is Ownable {
    mapping (address => address) public alkyneWallets;
    address[] registeredUsers;

    // Is this needed?
    mapping (address => uint256) public lensProfiles;

    address public swapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address public lensHubAddress = 0x5F3d9670C02e22c85Ba751E2EF59209c7be49561;
    address public alkyneFollowModule = 0x677ddAAeBa85FE0EAADaf7E216AD8e0a0f1e46CA;
    address public alkyneToken = 0x2dD9ce3fc29cb2d5218f003B2B4EedE996DD895F;

    function setSwapRouter(address _swapRouter) onlyOwner external {
        swapRouter = _swapRouter;
    }

    function setLensHubAddress(address _lensHubAddress) onlyOwner external {
        lensHubAddress = _lensHubAddress;
    }

    function setAlkyneFollowModule(address _alkyneFollowModule) onlyOwner external {
        alkyneFollowModule = _alkyneFollowModule;
    }

    function setAlkyneToken(address _alkyneToken) onlyOwner external {
        alkyneToken = _alkyneToken;
    }

    function getRegisteredUsers() external view returns (address [] memory) {
        return registeredUsers;
    }

    function getAlkyneWallet(address user) external view returns (address wallet) {
        return alkyneWallets[user];
    }

    function createProfile(string memory handle, string memory ipfsURI,uint256 maxAmount ) external returns (uint256 profileId, address alkyneWalletAddress) {
        registeredUsers.push(msg.sender);
        alkyneWalletAddress = address(new AlkyneWallet(swapRouter));
        alkyneWallets[msg.sender] = alkyneWalletAddress;

        ILensHub lensHub = ILensHub(lensHubAddress);

        DataTypes.CreateProfileData memory profileData = DataTypes.CreateProfileData({
            to: msg.sender,
            handle: handle,
            imageURI: ipfsURI,
            followModule: alkyneFollowModule,
            followModuleInitData: abi.encode(alkyneToken, msg.sender, alkyneWalletAddress, maxAmount),
            followNFTURI: ipfsURI
        });
        profileId = lensHub.createProfile(profileData);

        lensProfiles[msg.sender] = profileId;

        AlkyneToken(alkyneToken).mint(msg.sender, 100000000000000000000);
    }
}