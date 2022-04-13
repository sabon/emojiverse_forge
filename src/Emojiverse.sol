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
// @version  1.1.0
// @author   Radek Sienkiewicz | velvetshark.com
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Emojiverse is ERC721URIStorage, Ownable {
    constructor() ERC721("Emojiverse", "EMJV") {
  }
}
