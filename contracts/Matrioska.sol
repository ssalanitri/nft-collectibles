// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";


/**
 * @title Matrioska
 * Matrioska - a contract for my non-fungible matrioska.
 */
contract Matrioska is ERC721Tradable {
    constructor(address _proxyRegistryAddress)
        ERC721Tradable("Lovely Matrioska", "LMK", _proxyRegistryAddress)
    {}

    function baseTokenURI() override public pure returns (string memory) {
        return "https://nft-matrioskas-api.herokuapp.com/api/matrioska/";
    }

    function contractURI() public pure returns (string memory) {
        return "https://nft-matrioskas-api.herokuapp.com/contract/matrioska";
    }
}
