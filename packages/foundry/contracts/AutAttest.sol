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
        if (msg.sender != (owner())) revert Unauthorised();
        guarded = !guarded;
        emit GuardingStateChanged(guarded);
    }


    mapping(uint256 baseId => Interraction) interactionFromId;
    mapping(address => uint256[]) public userAttestations;



    /// @inheritdoc IAutAttest
    function addAttestationCondition(
        address targetContract,
        uint64 timestampDeadline,
        bytes4 selectedFx,
        uint256 chainID,
        string memory metadata
    ) external Guarded returns (uint256 attestationBaseID) {
        if (targetContract.code.length == 0) revert ImmaterialContract();
        attestationBaseID = getBaseID(targetContract, selectedFx, timestampDeadline);

        if ((msg.sender == (owner())) || userAttestations[address(uint160(attestationBaseID))].length == 0) {
            Interraction memory I;
            I.contractAddress = targetContract;
            I.selector = selectedFx;
            I.blockDeadline = timestampDeadline;
            I.metadataURI = metadata;
            I.chainID = chainID;
            interactionFromId[attestationBaseID] = I;
            userAttestations[address(uint160(attestationBaseID))].push(attestationBaseID);

            emit NewAttestationTypeCreated(attestationBaseID);
        } else {
            revert ExistsAlready();
        }
    }

    /// @inheritdoc IAutAttest
    function onChainAttestFor(address agent, uint160 attestationBaseID) external onlyOwner {
        if (userAttestations[address(attestationBaseID)].length == 0) revert UndefinedAttestation();

        unchecked {
            _mint(agent, uint256(uint160(bytes20(agent))) + attestationBaseID );
        }

        emit FulfillsCondition(attestationBaseID, agent);
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

    function getDefinition(uint256 baseID) external view returns (Interraction memory) {
        return interactionFromId[baseID];
    }

    /// @inheritdoc IAutAttest
    function hasMintedAttestationByID(address agent, uint256 attestationInstanceID) external view returns (bool) {
        return (ownerOf(uint256(uint160(bytes20(agent))) + attestationInstanceID ) == agent);
    }

    /// @inheritdoc IAutAttest
    function hasMintedAttestationByTarget(address agent, address target, bytes4 selector, uint256 maxBlockCutoff) external view returns (bool) {
        uint256 id = uint256(uint160(bytes20(agent))) + getBaseID( target,  selector,  maxBlockCutoff);
        
        return (_ownerOf(id) == agent);

    }

    function isRegisteredAttestationID(uint160 id) public view returns (bool) {
        return userAttestations[address(id)][0] == id;
    }
}
