//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IERC721} from "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
interface iARA is IERC721 {

    event createdAttestation(address target, uint256 attestationID);

    error ImmaterialContract();

    /// @notice creates attestation requirement
    /// @param selectedFx function selector of contract
    /// @param maxBlockCutoff retroactive time cutoff point
    function crudAttestationCondition(address targetContract, bytes4 selectedFx, uint256 maxBlockCutoff) external returns (uint256 attestationBaseID);


    /// @notice mints attestation fro a specific agent given an attestation BaseID
    /// @param agent attestation is for
    /// @param attestationBaseID the id of the already preconfigured attestation 
    /// @return tokenizedAttestationId id of atestation instance token
    function onChainAttestFor(address agent, uint256 attestationBaseID) external returns (uint256 tokenizedAttestationId);

    /// @notice checks if an address as a minted attestation of type attestationInstanceID
    function hasMintedAttestationByID(address agent, uint256 attestationInstanceID) external view returns (bool);

    /// @notice checks if an address as a minted attestation of type attestationInstanceID
    function hasMintedAttestationByTarget(address agent, uint256 attestationInstanceID) external view returns (bool);

}