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

        await nft.safeMint(seller.address);
        await nft.connect(seller).approve(nftMarketplace.target, 1);
        return { nftMarketplace, nft, owner, seller, buyer };
    }

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { nftMarketplace, owner } = await loadFixture(deployNFTMarketPlace);
            expect(await nftMarketplace.owner()).to.equal(owner.address);
        });
    });

    describe("Listing", function () {
        it("Should list an NFT", async function () {
            const { nftMarketplace, nft, seller, owner } = await loadFixture(deployNFTMarketPlace);
            // await nft.safeMint(seller.address);
            // await nft.connect(seller).approve(nftMarketplace.target, 1);
            await nftMarketplace.connect(seller).listNFT(1, nft.target, 1);
            // expect((await nftMarketplace.allListings(0)).nftAddress).to.equal(nft.target);
            expect(await nftMarketplace.listingCount()).to.equal(1);
        });
    });

   
    
    
});
    
