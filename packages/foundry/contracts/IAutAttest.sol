//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IERC721} from "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

struct Interraction {
    address contractAddress;
    bytes4 selector;
    uint64 blockDeadline;
    uint256 chainID;
    string metadataURI;
}

interface IAutAttest is IERC721 {
    event createdAttestation(address target, uint256 attestationID);
    event NewAttestationTypeCreated(uint256 indexed);
    event FulfillsCondition(uint256 indexed attestationBaseID, address agent);

    error ImmaterialContract();
    error Unauthorised();
    error UndefinedAttestation();
    error ExistsAlready();

    event GuardingStateChanged(bool);

    /// @notice creates attestation requirement
    /// @param targetContract contract address
    /// @param selectedFx function selector of contract
    /// @param timestampDeadline retroactive time cutoff point
    /// @return attestationBaseID ID of nft
    function addAttestationCondition(
        address targetContract,
        uint64 timestampDeadline,
        bytes4 selectedFx,
        uint256 chainID,
        string memory metadata
    ) external returns (uint256 attestationBaseID);

    function getBaseID(address target, bytes4 selector, uint256 maxBlockCutoff) external view returns (uint256 id);

    /// @notice mints attestation for a specific agent given an attestation BaseID
    /// @param agent attestation is for
    /// @param attestationBaseID the id of the already preconfigured attestation
    function onChainAttestFor(address agent, uint256 attestationBaseID) external;

    function getDefinition(uint256 baseID) external view returns (Interraction memory);

    /// @notice checks if an address as a minted attestation of type attestationInstanceID
    function hasMintedAttestationByID(address agent, uint256 attestationInstanceID) external view returns (bool);

    /// @notice checks if an address as a minted attestation of type attestationInstanceID
    function hasMintedAttestationByTarget(address agent, address target, bytes4 selector, uint256 maxBlockCutoff)
        external
        view
        returns (bool);
}
