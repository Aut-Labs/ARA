// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/AutAttest.sol";
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract AnERC20Contract is ERC20("token", "tkn") {}

contract ARATest is Test {
    AutAttest A;
    AnERC20Contract E20contract;

    address A0 =address(1234567890);
    address A1 = address(32456879734256754);
    address A2 = address(243567865432789786574635);

    function setUp() public {
        vm.prank(A0);
        A = new AutAttest();
    }

    function testIsDeployed() public {
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


    function testHappyPath() public {
        vm.prank(A0);
        A.flipGuarded();

        vm.prank(A1);
        vm.expectRevert();
        A.addAttestationCondition(address(E20contract), 0, 0xf1f1f2f2, 1, "");

        E20contract = new AnERC20Contract();
        if (address(E20contract).code.length == 0) revert("wuuut"); 
        vm.prank(A0);
        uint256 attestID = A.addAttestationCondition(address(E20contract), 0, 0xa1b1c2d2, 1, "");

        vm.prank(A1);
        vm.expectRevert();
        A.onChainAttestFor(A2,uint160(attestID));

        vm.prank(A0);
        A.onChainAttestFor(A2,uint160(attestID));


        assertTrue(A.hasMintedAttestationByID(A2,attestID), "should have attestation");
        assertTrue(A.balanceOf(A2) == 1, "no token minted");
        assertTrue(A.isRegisteredAttestationID(uint160(attestID)), "type does not exist");

        assertTrue(A.hasMintedAttestationByTarget(A2, address(E20contract),0xa1b1c2d2,1), "compute issue");
        assertFalse(A.hasMintedAttestationByTarget(A2, address(E20contract),0xa1b1c2d2,2), "compute issue");

    }
}
