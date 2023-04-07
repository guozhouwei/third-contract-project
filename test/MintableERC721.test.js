const MintableERC721 = artifacts.require("MintableERC721")

contract("MintableERC721", accounts => {
    it("MintNFT", async() => {
        const instance = await MintableERC721.deployed();
        const name = await instance.name.call();
        assert.equal(name, "Mintable NFT");
    })
})
