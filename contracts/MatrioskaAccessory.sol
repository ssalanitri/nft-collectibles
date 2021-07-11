// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC1155Tradable.sol";

/**
 * @title MatrioskaAccessory
 * MatrioskaAccessory - a contract for Matrioska Accessory semi-fungible tokens.
 */
contract MatrioskaAccessory is ERC1155Tradable {
    constructor(address _proxyRegistryAddress)
        ERC1155Tradable(
            "Lovely Matrioska Accessory",
            "LMKA",
            "https://matrioskas-api.opensea.io/api/accessory/{id}",
            _proxyRegistryAddress
        ) {}

    function contractURI() public pure returns (string memory) {
        return "https://matrioskas-api.opensea.io/contract/opensea-erc1155";
    }
}
