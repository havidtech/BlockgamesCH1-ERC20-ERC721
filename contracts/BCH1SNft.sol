// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../libraries/Base64.sol";

contract BCH1SNft is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping (uint => string) tokenIdToURI;

    constructor() ERC721("Blockgames CH1 Scholars", "BCH1S") {}

    function mint(address receiver, string memory name, string memory description, string memory imageUrl)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(receiver, newItemId);

        // Set tokenURI
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "',name,'"', '"description":  "',description,'"', '"image": "', imageUrl, '"}'))));
        tokenIdToURI[newItemId] = string(abi.encodePacked('data:application/json;base64,', json));

        return newItemId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        return tokenIdToURI[tokenId];
    }

    function totalSupply() public view returns (uint256){
        return _tokenIds.current();
    }

}