// SPDX-License-Identifier: UNLICENSED
/***
 *    oooooooooooo                                 o8o  o8o
 *    `888'     `8                                 `"'  `"'
 *     888         ooo. .oo.  .oo.    .ooooo.     oooo oooo  oooo    ooo  .ooooo.  oooo d8b  .oooo.o  .ooooo.
 *     888oooo8    `888P"Y88bP"Y88b  d88' `88b    `888 `888   `88.  .8'  d88' `88b `888""8P d88(  "8 d88' `88b
 *     888    "     888   888   888  888   888     888  888    `88..8'   888ooo888  888     `"Y88b.  888ooo888
 *     888       o  888   888   888  888   888     888  888     `888'    888    .o  888     o.  )88b 888    .o
 *    o888ooooood8 o888o o888o o888o `Y8bod8P'     888 o888o     `8'     `Y8bod8P' d888b    8""888P' `Y8bod8P'
 *                                                 888
 *                                             .o. 88P
 *                                             `Y888P
 */

// @title    Emojiverse
// @version  2.0.0
// @author   Radek Sienkiewicz | velvetshark.com
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Emojiverse is ERC721, Ownable {
  using Counters for Counters.Counter;

  Counters.Counter private _nextTokenId;

  struct SvgSquare {
    uint x;
    uint y;
    string y_offset;
    uint width;
    uint height;
    string rotation;
    string color;
    string message;
    string emoji;
    string msg_font_size;
    string emoji_font_size;
    uint256 randomBase;
    bool gm;
  }

  string[] private backgroundColors = [
    "rgb(1, 138, 178)",
    "rgb(104, 203, 171)",
    "rgb(110, 60, 188)",
    "rgb(114, 103, 203)",
    "rgb(118, 255, 226)",
    "rgb(119, 228, 212)",
    "rgb(152, 186, 231)",
    "rgb(153, 118, 255)",
    "rgb(153, 140, 235)",
    "rgb(157, 225, 22)",
    "rgb(158, 126, 93)",
    "rgb(168, 236, 231)",
    "rgb(176, 0, 185)",
    "rgb(178, 234, 112)",
    "rgb(180, 254, 152)",
    "rgb(180, 255, 199)",
    "rgb(182, 238, 170)",
    "rgb(187, 255, 159)",
    "rgb(194, 81, 237)",
    "rgb(199, 46, 65)",
    "rgb(200, 92, 92)",
    "rgb(203, 173, 255)",
    "rgb(207, 241, 205)",
    "rgb(209, 232, 228)",
    "rgb(212, 122, 232)",
    "rgb(221, 74, 72)",
    "rgb(226, 106, 44)",
    "rgb(229, 137, 10)",
    "rgb(236, 37, 90)",
    "rgb(237, 237, 237)",
    "rgb(240, 187, 98)",
    "rgb(240, 40, 252)",
    "rgb(246, 217, 197)",
    "rgb(249, 151, 93)",
    "rgb(249, 207, 242)",
    "rgb(251, 209, 72)",
    "rgb(251, 244, 109)",
    "rgb(251, 255, 0)",
    "rgb(252, 101, 97)",
    "rgb(252, 174, 223)",
    "rgb(253, 255, 143)",
    "rgb(254, 203, 227)",
    "rgb(255, 0, 0)",
    "rgb(255, 114, 120)",
    "rgb(255, 139, 162)",
    "rgb(255, 144, 54)",
    "rgb(255, 171, 76)",
    "rgb(255, 183, 110)",
    "rgb(255, 208, 127)",
    "rgb(255, 22, 147)",
    "rgb(255, 231, 128)",
    "rgb(255, 81, 81)",
    "rgb(255, 95, 126)",
    "rgb(46, 130, 255)",
    "rgb(52, 49, 108)",
    "rgb(57, 61, 124)",
    "rgb(6, 72, 122)",
    "rgb(65, 62, 83)",
    "rgb(73, 255, 0)",
    "rgb(81, 146, 89)",
    "rgb(84, 63, 88)",
    "rgb(86, 123, 130)",
    "rgb(87, 205, 229)",
    "rgb(93, 211, 255)"
  ];

  uint256 public maxSupply = 111;
  uint256 public mintPrice = 0.02 ether;
  
  constructor() ERC721("Emojiverse", "EMOJI") {
    // Increment _nextTokenId so that the first NFT has an ID of 1
    _nextTokenId.increment();

  }

  // Get the number of Emojiboards minted
  function totalSupply() public view returns (uint256) {
    return _nextTokenId.current() - 1;
  }

  function setMintPrice(uint256 newMintPrice) external onlyOwner {
    mintPrice = newMintPrice;
  }

  function createSvgSquare(
            uint16 x,
            uint16 y,
            string memory y_offset,
            uint16 width,
            uint16 height,
            string memory message,
            string memory emoji,
            string memory msg_font_size,
            string memory emoji_font_size,
            uint256 randomBase
            ) public view returns (SvgSquare memory) {
    
    bool gm = keccak256(abi.encodePacked(emoji)) == keccak256(abi.encodePacked("gm"));

    return
      SvgSquare({
        x: x,
        y: y,
        y_offset: y_offset,
        width: width,
        height: height,
        rotation: string.concat((randomBase % 2 == 0 ? "" : "-"), uint2str(randomBase % 120)), // Randomly flip the + or - sign, then random value from 0 to 120
        color: backgroundColors[(randomBase % 63)], // Choose random color from backgroundColors array
        message: gm ? "My message to the world..." : message,
        emoji: emoji,
        msg_font_size: msg_font_size,
        emoji_font_size: emoji_font_size,
        randomBase: randomBase,
        gm: gm
      });
  }

  function createSvgSquareCode(SvgSquare memory svgSquare) public pure returns (bytes memory) {
    // return string(abi.encodePacked(SvgSquareCodePartOne(svgSquare), SvgSquareCodePartTwo(svgSquare)));
    return abi.encodePacked(SvgSquareCodePartOne(svgSquare), SvgSquareCodePartTwo(svgSquare));
  }

  function SvgSquareCodePartOne(SvgSquare memory svgSquare) public pure returns (bytes memory) {
   return abi.encodePacked(
          '<svg x="',
          svgSquare.x,
          '" y="',
          svgSquare.y,
          '" width="',
          svgSquare.width,
          '" height="',
          svgSquare.height,
          '" viewBox="0 0 ',
          svgSquare.width,
          ' ',
          svgSquare.height,
          "' xmlns='http://www.w3.org/2000/svg'>",
          '<rect width="',
          svgSquare.width,
          '" height="',
          svgSquare.height,
          '" style="fill:',
          svgSquare.color,
          '" />'
    );
  }

  function SvgSquareCodePartTwo(SvgSquare memory svgSquare) public pure returns (bytes memory) {
   return abi.encodePacked(
          '<text x="5%" y="',
          svgSquare.y_offset,
          '" font-size="',
          svgSquare.msg_font_size,
          '" font-family="Monospace, Helvetica, sans-serif">',
          svgSquare.message,
          '</text><text x="50%" y="',
          svgSquare.gm ? '50%' : '60%',
          '" dominant-baseline="middle" font-family="Monospace, Helvetica, sans-serif" text-anchor="middle" font-size="',
          svgSquare.gm ? '380px' : '180px',
          '" transform="rotate(',
          svgSquare.rotation,
          ' 400 400)">',
          svgSquare.emoji,
          '</text>',
          '</svg>'
    );
  }


  // TODO Change to "internal"
  // Generate SVG for a big, one-block emojiboard
  function generateSvgOneTile(string memory emoji, string memory message) public view returns (bytes memory) {
    
    uint256 randomBase = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1))));

    // Create svgSquare struct
    SvgSquare memory svgSquare = createSvgSquare(0, 0, "8", 800, 800, message, emoji, "42px", "180px", randomBase);

    // Create svgSquare code
    return createSvgSquareCode(svgSquare);
  }

  // TODO Change to "internal"
  // Generate SVG for a two halves emojiboard
  function generateSvgTwoTiles(string[] memory emojis, string[] memory messages) public view returns (bytes memory) {
    
    uint256 randomBase = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1))));

    // svgSquare structs
    SvgSquare memory svgSquare1 = createSvgSquare(0, 0, "14", 800, 400, messages[0], emojis[0], "30px", "140px", randomBase);
    SvgSquare memory svgSquare2 = createSvgSquare(0, 400, "14", 800, 400, messages[1], emojis[1], "30px", "140px", randomBase >> 1);

    return abi.encodePacked(createSvgSquareCode(svgSquare1), createSvgSquareCode(svgSquare2));
  }

  // TODO Change to "internal"
  // Generate SVG for a two halves emojiboard
  function generateSvgThreeTiles(string[] memory emojis, string[] memory messages) public view returns (bytes memory) {
    
    uint256 randomBase = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1))));

    // svgSquare structs
    SvgSquare memory svgSquare1 = createSvgSquare(0, 0, "14", 800, 400, messages[0], emojis[0], "30px", "140px", randomBase);
    SvgSquare memory svgSquare2 = createSvgSquare(0, 400, "14", 400, 400, messages[1], emojis[1], "22px", "120px", randomBase >> 1);
    SvgSquare memory svgSquare3 = createSvgSquare(400, 400, "14", 400, 400, messages[2], emojis[2], "22px", "120px", randomBase >> 2);

    return abi.encodePacked(createSvgSquareCode(svgSquare1), createSvgSquareCode(svgSquare2), createSvgSquareCode(svgSquare3));
  }

  // TODO Change to "internal"
  // Generate SVG for a two halves emojiboard
  function generateSvgFourTiles(string[] memory emojis, string[] memory messages) public view returns (bytes memory) {
    
    uint256 randomBase = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1))));

    // svgSquare structs
    SvgSquare memory svgSquare1 = createSvgSquare(0, 0, "14", 400, 400, messages[0], emojis[0], "22px", "120px", randomBase);
    SvgSquare memory svgSquare2 = createSvgSquare(400, 0, "14", 400, 400, messages[0], emojis[0], "22px", "120px", randomBase >> 1);
    SvgSquare memory svgSquare3 = createSvgSquare(0, 400, "14", 400, 400, messages[1], emojis[1], "22px", "120px", randomBase >> 2);
    SvgSquare memory svgSquare4 = createSvgSquare(400, 400, "14", 400, 400, messages[2], emojis[2], "22px", "120px", randomBase >> 3);

    return abi.encodePacked(createSvgSquareCode(svgSquare1), createSvgSquareCode(svgSquare2), createSvgSquareCode(svgSquare3), createSvgSquareCode(svgSquare4));
  }

  // Generate token SVG based on the emojis and messages
  function generateTokenSVG(string[] memory emojis, string[] memory messages, uint tokenId) private view returns (string memory innerSVG) {
  
    // If one square, return the svg for just that one square
    if (emojis.length == 1) {
      return string(generateSvgOneTile(emojis[0], messages[0]));
    }

    // If two squares, return inner squares' svg and outer wrapper
    if (emojis.length == 2) {
      return
        string(
          abi.encodePacked(
            '<svg width="800" height="800" viewBox="0 0 800 800" xmlns="http://www.w3.org/2000/svg">',
            generateSvgTwoTiles(emojis, messages),
            '</svg>'
          )
        );
    }
 
    // If three squares, return inner squares' svg and outer wrapper
    if (emojis.length == 3) {
      return
        string(
          abi.encodePacked(
            '<svg width="800" height="800" viewBox="0 0 800 800" xmlns="http://www.w3.org/2000/svg">',
            generateSvgThreeTiles(emojis, messages),
            '</svg>'
          )
        );
    }

    // If four squares, return inner squares' svg and outer wrapper
    if (emojis.length == 4) {
      return
        string(
          abi.encodePacked(
            '<svg width="800" height="800" viewBox="0 0 800 800" xmlns="http://www.w3.org/2000/svg">',
            generateSvgFourTiles(emojis, messages),
            '</svg>'
          )
        );
    }
  }


  // From: https://stackoverflow.com/a/65707309/11969592
  function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
    if (_i == 0) {
      return "0";
    }
    uint256 j = _i;
    uint256 len;
    while (j != 0) {
      len++;
      j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint256 k = len;
    while (_i != 0) {
      k = k - 1;
      uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
      bytes1 b1 = bytes1(temp);
      bstr[k] = b1;
      _i /= 10;
    }
    return string(bstr);
  }

}
