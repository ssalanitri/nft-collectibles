/* Contracts in this test */

const MatrioskaAccessory = artifacts.require(
  "../contracts/MatrioskaAccessory.sol"
);


contract("MatrioskaAccessory", (accounts) => {
  const URI_BASE = 'https://nft-matrioskas-api.herokuapp.com';
  const CONTRACT_URI = `${URI_BASE}/contract/opensea-erc1155`;
  let MatrioskaAccessory;

  before(async () => {
    MatrioskaAccessory = await MatrioskaAccessory.deployed();
  });

  // This is all we test for now

  // This also tests contractURI()

  describe('#constructor()', () => {
    it('should set the contractURI to the supplied value', async () => {
      assert.equal(await MatrioskaAccessory.contractURI(), CONTRACT_URI);
    });
  });
});
