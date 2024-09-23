import hre from "hardhat";
import { expect } from "chai";

import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";

describe("NFTMarketPlace", function () {
    async function deployNFTMarketPlace() {
        const [owner, seller, buyer] = await hre.ethers.getSigners();

        const NFTMarketPlace = await hre.ethers.getContractFactory("NFTMarketPlace");
        const nftMarketplace = await NFTMarketPlace.deploy(owner.address);

        const NFT = await hre.ethers.getContractFactory("NFT");
        const nft = await NFT.deploy(owner.address);

        // await nft.safeMint(seller.address);
        // await nft.connect(seller).approve(nftMarketplace.target, 1);
        // console.log(owner.address, seller.address, buyer.address)
        // console.log('nftMarketplace', nftMarketplace.target)
        // console.log('nft', nft.target)
        return { nftMarketplace, nft, owner, seller, buyer };
    }

    describe("Deployment", function () {
        it("Should set the right owner nftmarketplace", async function () {
            const { nftMarketplace, owner } = await loadFixture(deployNFTMarketPlace);
            expect(await nftMarketplace.owner()).to.equal(owner.address);
        });

        it("Should set the right owner nft", async function () {
            const { nft, owner } = await loadFixture(deployNFTMarketPlace);
            expect(await nft.owner()).to.equal(owner.address);
        });
    });

    describe("Listing", function () {
        it("Should list an NFT", async function () {
            const { nftMarketplace, nft, seller, owner } = await loadFixture(deployNFTMarketPlace);

            await nft.safeMint(seller.address);

            console.log(await nft.ownerOf(1), seller.address,  owner.address)
            await nft.connect(seller).approve(nftMarketplace, 1);

            await nftMarketplace.connect(seller).listNFT(1, nft.target, 1);
            expect((await nftMarketplace.allListings(1)).tokenId).to.equal(1);
            expect(await nftMarketplace.listingCount()).to.equal(1);
        });
    });

   
    
    
});
    
