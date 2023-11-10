// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/ARA.sol";

contract ARATest is Test {
    ARA A;
    function setUp() public {
        A = new ARA();
    }

    function testIsDeployed() public  {
        assertTrue(address(A) != address(0), "not A0");
        assertTrue(address(A).code.length > 0, "no code at address");
        assertTrue(A.owner() != address(0), "owner is 0");
    }

    function testCreatesAttestation() public {
        vm.skip(true);
    }

    function testMintsAttestation() public {
        vm.skip(true);
    }

    function testIndexingStructure() public {
                vm.skip(true);
    }
}
