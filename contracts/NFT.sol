// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _tokenIds;  

    constructor(address initialOwner)
        ERC721("FaveNFT", "FNT")
        Ownable(initialOwner)
    {}

    function safeMint(address to)
        public
        onlyOwner
    {
        string memory uri = "https://violet-major-ocelot-686.mypinata.cloud/ipfs/QmXa4YijjEAD7Gr7nBsd3oMKFpj2usR8vW9bcFs6DSxgUe";
        require(_tokenIds < 10000, "No more NFTs can be minted");
        _tokenIds++;
        uint256 newItemId = _tokenIds;
        _safeMint(to, newItemId);
        _setTokenURI(newItemId, uri);
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}