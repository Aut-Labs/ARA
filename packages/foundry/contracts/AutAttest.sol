//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {IAutAttest, Interraction} from "./IAutAttest.sol";

contract AutAttest is Ownable(msg.sender), ERC721("Aut Attestation", "AutAtt"), IAutAttest {
    bool public guarded;

    modifier Guarded() {
        if (guarded) if (msg.sender != owner()) revert Unauthorised();
        _;
    }

    function flipGuarded() external {
        if (msg.sender != owner()) revert Unauthorised();
        guarded = !guarded;
        emit GuardingStateChanged(guarded);
    }

    mapping(uint256 baseId => Interraction) interactionFromId;
    mapping(uint256 baseId => uint256 last) lastID;

    /// @inheritdoc IAutAttest
    function addAttestationCondition(
        address targetContract,
        bytes4 selectedFx,
        uint64 maxBlockCutoff,
        string memory metadata
    ) external Guarded returns (uint256 attestationBaseID) {
        if (targetContract.code.length == 0) revert ImmaterialContract();
        attestationBaseID = getBaseID(targetContract, selectedFx, maxBlockCutoff);

        if (lastID[attestationBaseID] == 0) {
            Interraction memory I;
            I.contractAddress = targetContract;
            I.selector = selectedFx;
            I.blockDeadline = maxBlockCutoff;
            I.metadataURI = metadata;
            interactionFromId[attestationBaseID] = I;
            lastID[attestationBaseID] = attestationBaseID;

            emit NewAttestationTypeCreated();
        }
    }

    /// @inheritdoc IAutAttest
    function onChainAttestFor(address agent, uint256 attestationBaseID) external onlyOwner {
        if (lastID[attestationBaseID] == 0) revert UndefinedAttestation();
        lastID[attestationBaseID]++;
        _mint(agent, lastID[attestationBaseID]);
    }

    function getBaseID(address target, bytes4 selector, uint256 maxBlockCutoff) public view returns (uint256 id) {
        id = uint256(uint160(target) / uint256(uint32(selector)));
        if (maxBlockCutoff > 0) id = id / maxBlockCutoff;
    }


    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return interactionFromId[tokenId].metadataURI;
    }

    //////////////////////////////////////////
    ///////////// VIEW
    //////////////////////////////////////////

    /// @inheritdoc IAutAttest
    function hasMintedAttestationByID(address agent, uint256 attestationInstanceID) external view returns (bool) {}

    /// @inheritdoc IAutAttest
    function hasMintedAttestationByTarget(address agent, uint256 attestationInstanceID) external view returns (bool) {}
}
