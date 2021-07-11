// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";

/**
 * @title Matrioska
 * Matrioska - a contract for my non-fungible creatures.
 */
contract Matrioska is ERC721Tradable {
    constructor(address _proxyRegistryAddress)
        ERC721Tradable("Matrioska", "OSC", _proxyRegistryAddress)
    {}

    function baseTokenURI() override public pure returns (string memory) {
        return "https://creatures-api.opensea.io/api/matrioska/";
    }

    function contractURI() public pure returns (string memory) {
        return "https://creatures-api.opensea.io/contract/opensea-creatures";
    }
}
