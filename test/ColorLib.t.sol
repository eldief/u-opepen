// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src//lib/ColorLib.sol";

contract ColorLibTest is Test {
    function setUp() public {}

    function testPackUnpackColors(bytes3 b3Color) public {
        uint24 u24Color = uint24(b3Color);

        uint256 packedData;
        bytes3 unpackedB3Color;
        uint24 unpackedU24Color;

        for (uint256 i; i < 10; ++i) {
            // 256 // 24 = 10
            uint256 prevPackedData = packedData;

            packedData = ColorLib.packColor(packedData, i, u24Color);
            assertTrue(prevPackedData <= packedData);

            unpackedU24Color = ColorLib.unpackColor(packedData, i);
            assertEq(u24Color, unpackedU24Color);

            unpackedB3Color = bytes3(unpackedU24Color);
            assertEq(b3Color, unpackedB3Color);
        }

        packedData = 0;
        for (uint256 i = 10; i < 20; ++i) {
            uint256 prevPackedData = packedData;

            packedData = ColorLib.packColor(packedData, i, u24Color);
            assertTrue(prevPackedData <= packedData);

            unpackedU24Color = ColorLib.unpackColor(packedData, i);
            assertEq(u24Color, unpackedU24Color);

            unpackedB3Color = bytes3(unpackedU24Color);
            assertEq(b3Color, unpackedB3Color);
        }
    }

    function testPackUnpackBackground(bytes3 b3Background) public {
        uint24 u24Background = uint24(b3Background);

        uint256 packedData;
        uint256 packedData2;
        bytes3 unpackedB3Background;
        uint24 unpackedU24Background;

        uint256 prevPackedData = packedData;
        uint256 prevPackedData2 = packedData2;

        (packedData, packedData2) = ColorLib.packBackground(packedData, packedData2, u24Background);
        assertTrue(prevPackedData <= packedData);
        assertTrue(prevPackedData2 <= packedData2);

        unpackedU24Background = ColorLib.unpackBackground(packedData, packedData2);
        assertEq(u24Background, unpackedU24Background);

        unpackedB3Background = bytes3(unpackedU24Background);
        assertEq(b3Background, unpackedB3Background);
    }
}
