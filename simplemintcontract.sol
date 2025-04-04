// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SimpleMintContract is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    uint256 public maxSupply;
    uint256 public mintPrice;
    bool public isMintingActive;
    mapping(address => uint256) public mintedWallets;

    event MintPriceChanged(uint256 newPrice);
    event Minted(address indexed to, uint256 tokenId);

    constructor() ERC721("Mint Klo", "MK") {
        maxSupply = 1000;
        mintPrice = 0.05 ether;
    }

    function toggleIsMintEnabled() external onlyOwner {
        isMintingActive = !isMintingActive;
    }

    function setMaxSupply(uint256 maxSupply_) external onlyOwner {
        require(maxSupply_ >= _tokenIds.current(), "Cannot set max supply below current supply");
        maxSupply = maxSupply_;
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
        emit MintPriceChanged(newPrice);
    }

    function mint() external payable nonReentrant {
        require(isMintingActive, "Minting is not active");
        require(mintedWallets[msg.sender] < 1, "You have already minted");
        require(_tokenIds.current() < maxSupply, "sold out");
        require(msg.value >= mintPrice, "wrong mint price");

        mintedWallets[msg.sender]++;
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint(msg.sender, newTokenId);
        
        emit Minted(msg.sender, newTokenId);
    }

    function withdraw() external onlyOwner nonReentrant {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }
}

