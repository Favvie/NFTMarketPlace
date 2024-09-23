// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarketPlace {
    address public owner;
    uint256 public listingCount;

    struct Listing {
        address nftAddress;
        uint tokenId;
        address seller;
        uint price;
    }

    mapping (uint => Listing) public allListings;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    event NFTListed(uint tokenId, address seller, uint price);
    event NFTBought(uint tokenId, address buyer, uint price);
    event ListingRemoved(uint256 tokenId, address seller);
    event ListingUpdated(uint256 tokenId, uint256 newPrice);

    constructor(address initialOwner) {
        owner = initialOwner;
    }

    function listNFT(uint256 tokenId, address nftAddress, uint256 price) public {
        // Create an interface to interact with the NFT contract
        IERC721 nftContract = IERC721(nftAddress);
        
        // Check if the NFT exists and if the sender is the owner
        require(nftContract.ownerOf(tokenId) == msg.sender, "You don't own this NFT");
        
        // Ensure the price is greater than zero
        require(price > 0, "Price must be greater than zero");

        // Approve the marketplace contract to transfer the NFT
        
        // **Add a check for approval**
        require(
            nftContract.getApproved(tokenId) == address(this) || 
            nftContract.isApprovedForAll(msg.sender, address(this)),
            "Marketplace not approved to transfer this NFT"
        );

        // Add the NFT to the marketplace listings
        allListings[tokenId] = Listing(nftAddress, tokenId, msg.sender, price);
        
        // Emit an event for the new listing
        emit NFTListed(tokenId, msg.sender, price);

        listingCount++;
    }

    function buyNFT(uint256 tokenId) public payable {
        // Get the listing details
        Listing storage listing = allListings[tokenId];
        
        // Ensure the listing exists and the price is correct
        require(listing.nftAddress != address(0), "NFT is not listed");
        require(msg.value == listing.price, "Incorrect price");
        
        // Transfer the NFT to the buyer
        IERC721(listing.nftAddress).transferFrom(listing.seller, msg.sender, listing.tokenId);
        
        // Transfer the ether to the seller
        payable(listing.seller).transfer(msg.value);
        
        // Remove the listing
        delete allListings[tokenId];
        
        // Emit an event for the NFT purchase
        emit NFTBought(tokenId, msg.sender, msg.value);
    }

    function removeListing(uint256 tokenId) public {
        Listing storage listing = allListings[tokenId];
        require(listing.seller == msg.sender, "Only the seller can remove the listing");
        delete allListings[tokenId];
        emit ListingRemoved(tokenId, msg.sender);
    }

    function getListing(uint256 tokenId) public view returns (Listing memory) {
        return allListings[tokenId];
    }

    function getAllListings() public view returns (Listing[] memory) {
        Listing[] memory listings = new Listing[](listingCount);
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < listingCount; i++) {
            if (allListings[i].nftAddress != address(0)) {
                listings[currentIndex] = allListings[i];
                currentIndex++;
            }
        }
        return listings;
    }

    function updateListingPrice(uint256 tokenId, uint256 newPrice) public {
        Listing storage listing = allListings[tokenId];
        require(listing.seller == msg.sender, "Only the seller can update the price");
        require(newPrice > 0, "Price must be greater than zero");
        listing.price = newPrice;
        emit ListingUpdated(tokenId, newPrice);
    }
    
}
