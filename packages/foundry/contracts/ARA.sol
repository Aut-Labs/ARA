//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";

import {Ownable } from "openzeppelin-contracts/contracts/access/Ownable.sol";
import { ERC721 } from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import { iARA } from "./IARA.sol";

contract ARA is Ownable(msg.sender), ERC721("Aut Retroactive Attestation", "AutRA"), iARA {

    mapping(uint256 base => uint256[2] CutOff_Last) lastID;

    /// @inheritdoc iARA
    function crudAttestationCondition(address targetContract, bytes4 selectedFx, uint256 maxBlockCutoff) external onlyOwner returns (uint256 attestationBaseID){
        if (targetContract.code.length == 0) revert ImmaterialContract();
        if (maxBlockCutoff == 0) maxBlockCutoff = block.timestamp;
        attestationBaseID = _attestationID(targetContract, selectedFx);
        if (lastID[attestationBaseID][1] == 0 ) lastID[attestationBaseID][1] = attestationBaseID;
    }

   /// @inheritdoc iARA
    function onChainAttestFor(address agent, uint256 attestationBaseID) external onlyOwner returns (uint256 tokenizedAttestationId) {

    }

    function _attestationID(address target, bytes4 selector) private returns (uint256) {
        return uint256(uint160(target) / uint256(uint32(selector)));
    }








//////////////////////////////////////////
///////////// VIEW
//////////////////////////////////////////

   /// @inheritdoc iARA
   function hasMintedAttestationByID(address agent, uint256 attestationInstanceID) external view returns (bool){}

   /// @inheritdoc iARA
   function hasMintedAttestationByTarget(address agent, uint256 attestationInstanceID) external view returns (bool){}


}
