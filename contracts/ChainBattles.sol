// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";


contract ChainBattles is ERC721URIStorage{
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

   

    struct Stats {
        uint level;
        uint speed;
        uint strength;
        uint life;
    }

     mapping(uint256 => Stats) tokenIdToStats;
    constructor ()ERC721("ChainBattles","CBTLS"){
        
    }

        
    
    function randomNum(uint256 _number) public view returns(uint256){
      uint256 num=uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty)))%_number;
      return num;
    }

    function generateCharacter(uint256 _tokenId) view public returns(string memory){

    Stats memory stats=getStats(_tokenId);
    string memory lev=(stats.level).toString();
    string memory spd=(stats.speed).toString();
    string memory str=(stats.strength).toString();
    string memory lyf=(stats.life).toString();

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 24px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",lev,'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",spd," m/s"'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",str,'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",lyf," years"'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
    }

    function getStats(uint256 _tokenId)public view returns(Stats memory){
            return tokenIdToStats[_tokenId];
    }

    function getTokenURI(uint256 _tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', _tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(_tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}

    function mint()public {
        _tokenIds.increment();
        uint256 newItemId=_tokenIds.current();
        _safeMint(msg.sender, newItemId);
        Stats memory init;
        init.level=randomNum(50);
        init.speed=20+randomNum(200);
        init.strength=randomNum(1000);
        init.life=randomNum(100);
        tokenIdToStats[newItemId]=init;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 _tokenId)public{
        require(_exists(_tokenId),"Please use an Existing Token");
        require(msg.sender==ownerOf(_tokenId),"You must own the token to train it!");
        Stats memory currentStats=tokenIdToStats[_tokenId];
        Stats memory updatedStats;
        updatedStats.level=currentStats.level+1;
        updatedStats.speed=currentStats.speed+randomNum(20);
        updatedStats.strength=currentStats.strength+randomNum(250);
        updatedStats.life=currentStats.life+randomNum(40);
        tokenIdToStats[_tokenId]=updatedStats;
        _setTokenURI(_tokenId, getTokenURI(_tokenId));
    }



}