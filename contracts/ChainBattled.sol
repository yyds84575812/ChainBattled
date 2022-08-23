// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => uint256) public tokenIdToLevels;
    mapping(uint256 => uint256) public tokenIdToSpeeds;
    mapping(uint256 => uint256) public tokenIdToPowers;
    mapping(uint256 => uint256) public tokenIdTolifes;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    function generateCharacter(uint256 tokenId) public returns(string memory){

        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speeds: ",getSpeeds(tokenId),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Powers: ",getPowers(tokenId),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Lifes: ",getLifes(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )
        );
    }
    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevels[tokenId];
        return levels.toString();
    }
    function getSpeeds(uint256 tokenId) public view returns (string memory) {
        uint256 speeds = tokenIdToSpeeds[tokenId];
        return speeds.toString();
    }
    function getPowers(uint256 tokenId) public view returns (string memory) {
        uint256 powers = tokenIdToPowers[tokenId];
        return powers.toString();
    }
    function getLifes(uint256 tokenId) public view returns (string memory) {
        uint256 lifes = tokenIdTolifes[tokenId];
        return lifes.toString();
    }
    function getTokenURI(uint256 tokenId) public returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }
    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId] = 0;
        tokenIdToSpeeds[newItemId] = 0;
        tokenIdToPowers[newItemId] = 0;
        tokenIdTolifes[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public{
        require(_exists(tokenId),"The tokenId does not exist");
        require(_isApprovedOrOwner(msg.sender, tokenId),"You are not the owner of the NFT");
        tokenIdToLevels[tokenId] += 1;
        tokenIdToSpeeds[tokenId] += 1;
        tokenIdToPowers[tokenId] += 1;
        tokenIdTolifes[tokenId] += 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}