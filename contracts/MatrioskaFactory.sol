// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/utils/Strings.sol";
import "./IFactoryERC721.sol";
import "./Matrioska.sol";
import "./MatrioskaLootBox.sol";

contract MatrioskaFactory is FactoryERC721, Ownable {
    using Strings for string;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    address public proxyRegistryAddress;
    address public nftAddress;
    address public lootBoxNftAddress;
    string public baseURI = "https://Matrioskas-api.opensea.io/api/factory/";

    /*
     * Enforce the existence of only 100 OpenSea Matrioskas.
     */
    uint256 Matrioska_SUPPLY = 100;

    /*
     * Three different options for minting Matrioskas (basic, premium, and gold).
     */
    uint256 NUM_OPTIONS = 3;
    uint256 SINGLE_Matrioska_OPTION = 0;
    uint256 MULTIPLE_Matrioska_OPTION = 1;
    uint256 LOOTBOX_OPTION = 2;
    uint256 NUM_MatrioskaS_IN_MULTIPLE_Matrioska_OPTION = 4;

    constructor(address _proxyRegistryAddress, address _nftAddress) {
        proxyRegistryAddress = _proxyRegistryAddress;
        nftAddress = _nftAddress;
        lootBoxNftAddress = address(
            new MatrioskaLootBox(_proxyRegistryAddress, address(this))
        );

        fireTransferEvents(address(0), owner());
    }

    function name() override external pure returns (string memory) {
        return "OpenSeaMatrioska Item Sale";
    }

    function symbol() override external pure returns (string memory) {
        return "CPF";
    }

    function supportsFactoryInterface() override public pure returns (bool) {
        return true;
    }

    function numOptions() override public view returns (uint256) {
        return NUM_OPTIONS;
    }

    function transferOwnership(address newOwner) override public onlyOwner {
        address _prevOwner = owner();
        super.transferOwnership(newOwner);
        fireTransferEvents(_prevOwner, newOwner);
    }

    function fireTransferEvents(address _from, address _to) private {
        for (uint256 i = 0; i < NUM_OPTIONS; i++) {
            emit Transfer(_from, _to, i);
        }
    }

    function mint(uint256 _optionId, address _toAddress) override public {
        // Must be sent from the owner proxy or owner.
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        assert(
            address(proxyRegistry.proxies(owner())) == _msgSender() ||
                owner() == _msgSender() ||
                _msgSender() == lootBoxNftAddress
        );
        require(canMint(_optionId));

        Matrioska openSeaMatrioska = Matrioska(nftAddress);
        if (_optionId == SINGLE_Matrioska_OPTION) {
            openSeaMatrioska.mintTo(_toAddress);
        } else if (_optionId == MULTIPLE_Matrioska_OPTION) {
            for (
                uint256 i = 0;
                i < NUM_MatrioskaS_IN_MULTIPLE_Matrioska_OPTION;
                i++
            ) {
                openSeaMatrioska.mintTo(_toAddress);
            }
        } else if (_optionId == LOOTBOX_OPTION) {
            MatrioskaLootBox openSeaMatrioskaLootBox = MatrioskaLootBox(
                lootBoxNftAddress
            );
            openSeaMatrioskaLootBox.mintTo(_toAddress);
        }
    }

    function canMint(uint256 _optionId) override public view returns (bool) {
        if (_optionId >= NUM_OPTIONS) {
            return false;
        }

        Matrioska openSeaMatrioska = Matrioska(nftAddress);
        uint256 MatrioskaSupply = openSeaMatrioska.totalSupply();

        uint256 numItemsAllocated = 0;
        if (_optionId == SINGLE_Matrioska_OPTION) {
            numItemsAllocated = 1;
        } else if (_optionId == MULTIPLE_Matrioska_OPTION) {
            numItemsAllocated = NUM_MatrioskaS_IN_MULTIPLE_Matrioska_OPTION;
        } else if (_optionId == LOOTBOX_OPTION) {
            MatrioskaLootBox openSeaMatrioskaLootBox = MatrioskaLootBox(
                lootBoxNftAddress
            );
            numItemsAllocated = openSeaMatrioskaLootBox.itemsPerLootbox();
        }
        return MatrioskaSupply < (Matrioska_SUPPLY - numItemsAllocated);
    }

    function tokenURI(uint256 _optionId) override external view returns (string memory) {
        return string(abi.encodePacked(baseURI, Strings.toString(_optionId)));
    }

    /**
     * Hack to get things to work automatically on OpenSea.
     * Use transferFrom so the frontend doesn't have to worry about different method names.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public {
        mint(_tokenId, _to);
    }

    /**
     * Hack to get things to work automatically on OpenSea.
     * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
     */
    function isApprovedForAll(address _owner, address _operator)
        public
        view
        returns (bool)
    {
        if (owner() == _owner && _owner == _operator) {
            return true;
        }

        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (
            owner() == _owner &&
            address(proxyRegistry.proxies(_owner)) == _operator
        ) {
            return true;
        }

        return false;
    }

    /**
     * Hack to get things to work automatically on OpenSea.
     * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
     */
    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return owner();
    }
}
