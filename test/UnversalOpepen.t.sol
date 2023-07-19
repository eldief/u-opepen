// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {USBT} from "usbt/USBT.sol";
import "../src/UnversalOpepen.sol";

contract UniversalOpepenTest is Test {
    UnversalOpepen public uOpepen;
    UniversalOpepenRenderer public renderer;

    address operator;
    uint256 public invalidTokenId = uint256(1) + type(uint160).max;

    function setUp() public {
        operator = makeAddr("operator");

        vm.startPrank(operator, operator);

        renderer = new UniversalOpepenRenderer();
        uOpepen = new UnversalOpepen(address(renderer));

        vm.stopPrank();
    }

    function testClaim(bytes3[21] memory colors) public {
        vm.startPrank(operator, operator);

        uint256 tokenId = uint256(uint160(operator));
        uOpepen.claim(colors);

        bytes3[] memory storedColors = uOpepen.colors(uint160(tokenId));
        for (uint256 i; i < 20; ++i) {
            assertEq(storedColors[i], colors[i]);
        }
        assertEq(storedColors[20], colors[20]);

        vm.stopPrank();
    }

    function testEdit(bytes3[21] memory claimColors, bytes3[21] memory editColors) public {
        vm.startPrank(operator, operator);

        uint256 tokenId = uint256(uint160(operator));
        uOpepen.claim(claimColors);
        uOpepen.edit(editColors);

        bytes3[] memory storedColors = uOpepen.colors(uint160(tokenId));
        for (uint256 i; i < 20; ++i) {
            assertEq(storedColors[i], editColors[i]);
        }
        assertEq(storedColors[20], editColors[20]);

        vm.stopPrank();
    }

    function testColor(bytes3[21] memory colors) public {
        vm.startPrank(operator, operator);

        uint256 tokenId = uint256(uint160(operator));

        uOpepen.claim(colors);

        vm.expectRevert(USBT.InvalidTokenId.selector);
        uOpepen.color(invalidTokenId, 0);

        vm.expectRevert(UnversalOpepen.InvalidSlot.selector);
        uOpepen.color(tokenId, 21);

        for (uint256 i; i < 21; ++i) {
            assertEq(uOpepen.color(tokenId, i), colors[i]);
        }

        vm.stopPrank();
    }

    function testColors(bytes3[21] memory colors) public {
        vm.startPrank(operator, operator);

        uint256 tokenId = uint256(uint160(operator));
        uOpepen.claim(colors);

        vm.expectRevert(USBT.InvalidTokenId.selector);
        uOpepen.colors(invalidTokenId);

        bytes3[] memory storedColors = uOpepen.colors(tokenId);
        for (uint256 i; i < 21; ++i) {
            assertEq(storedColors[i], colors[i]);
        }

        vm.stopPrank();
    }

    function testTokenURI(address _operator, bytes3[21] memory colors) public {
        vm.startPrank(_operator, _operator);

        uint256 tokenId = uint256(uint160(_operator));
        uOpepen.claim(colors);

        assertTrue(bytes(uOpepen.tokenURI(tokenId)).length > 0);

        vm.stopPrank();
    }

    function testLogTokenURI() public {
        vm.startPrank(operator, operator);

        bytes3[21] memory colors;
        colors[0] = 0xb3efea;
        colors[1] = 0xb3efea;
        colors[2] = 0xb3efea;
        colors[3] = 0xb3efea;

        colors[4] = 0x000000;
        colors[5] = 0xFFFFFF;
        colors[6] = 0x000000;
        colors[7] = 0xFFFFFF;

        colors[8] = 0x009b8e;
        colors[9] = 0xb3efea;
        colors[10] = 0x009b8e;
        colors[11] = 0xb3efea;

        colors[12] = 0x000000;
        colors[13] = 0xb3efea;
        colors[14] = 0x000000;
        colors[15] = 0xb3efea;
        
        colors[16] = 0x00554e;
        colors[17] = 0x00554e;
        colors[18] = 0x00554e;
        colors[19] = 0x00554e;

        colors[20] = 0xb01293;

        uint256 tokenId = uint256(uint160(operator));
        uOpepen.claim(colors);
        console.log(uOpepen.tokenURI(tokenId));
    }
}
