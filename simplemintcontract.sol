// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleMintContract is ERC721, Ownable {
    uint256 public maxSupply;
    uint256 public totalSupply;
    uint256 public mintPrice = 0.05 ether;
    bool public isMintingActive;
    

   
        
}

