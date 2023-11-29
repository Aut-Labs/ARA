import React, { useState } from "react";
import Link from "next/link";
import { hardhat } from "viem/chains";
import { getTargetNetwork } from "~~/utils/scaffold-eth";
import {useScaffoldContractWrite} from "~~/hooks/scaffold-eth";
import { off } from "process";
import { EtherscanProvider } from "@ethersproject/providers";
import { create } from "domain";
import { numberToBytes } from "viem";
/**
 * Site footer
 */
export const CreateBadgeForm = () => {
  const isLocalNetwork = getTargetNetwork().id === hardhat.id;


  // let createArgs: {name: string, targetContract: `0x${string}`, functionSelector: string, chainID: number, logoUrl: string, docsUrl: string, description: string }

  const [formData, setFormData] = useState({

    targetContract: "",
    timestampDeadline: "",
    functionSelector: "",
    chainID: getTargetNetwork().id,
    logoUrl: "",
    docsUrl: "",
    description: "",
    name: "",
  });

  const handleInput = (e: any) => {
    const fieldName = e.target.name;
    let fieldValue = e.target.value;
    setFormData((prevState) => ({
      ...prevState,
      [fieldName]: fieldValue
    }));
  }
  // address targetContract,
  // uint64 timestampDeadline,
  // bytes4 selectedFx,
  // uint256 chainID,
  // string memory metadata
  // function createBadge() {

  //   let metadata = {}

  //   let metadataUri: string = "";

  //   writeAsync();
  // }

  const { writeAsync, isLoading, isMining }  = useScaffoldContractWrite({
    contractName: "AutAttest",
    functionName: "addAttestationCondition",
    args: [
      `0x${formData.targetContract.slice(2)}`,
      BigInt(0),
      `0x${formData.functionSelector}`, //
      BigInt(formData.chainID), // Convert description to bigint
      "metadataUri"
    ],
    blockConfirmations: 1,
    // The callback function to execute when the transaction is confirmed.
    onBlockConfirmation: txnReceipt => {
      console.log("Transaction blockHash", txnReceipt.blockHash);
    }
  })




  return (
<>
<div className="createFormArea" id="create-form">

<div className="form-control w-full max-w-xs">
<h4 className="text text-5xl">Create Badge</h4>
<br />
<label className="label">
<h3 className="label-text">Action Description</h3>
</label>
<input type="text" placeholder="Minted Turtle NFT" className="input input-bordered input-info info-aut w-full max-w-xs" name="name" onChange={handleInput} />
<label className="label">
<span className="label-text">Target Contract Address</span>
</label>
<input type="text" placeholder="0x2aa903a6dE876d6f6b8a156b96F8370f824Cd8AB" className="input input-bordered input-info info-aut w-full max-w-xs" name="targetContract" onChange={handleInput}  />
<label className="label">
<span className="label-text">Function Selector</span>
</label>
<input type="text" placeholder="transferTokenTo(uint256,address)" className="input input-bordered input-info info-aut w-full max-w-xs" name="functionSelector" onChange={handleInput} />
<label className="label">
<span className="label-text">Chain ID</span>
</label>
<input type="number" placeholder={String(getTargetNetwork().id)} className="input input-bordered input-info info-aut w-full max-w-xs"  name="chainID" onChange={handleInput}  />
<label className="label">
<span className="label-text">Logo url</span>
</label>
<input type="text" placeholder="http://google.com/logo.png" className="input input-bordered input-info info-aut w-full max-w-xs" name="logoUrl" onChange={handleInput} />
<label className="label">
<span className="label-text">Link to protocol documentation</span>
</label>
<input type="text" placeholder="http://turtle-protocol.xyz/docs/contracts" className="input input-bordered input-info info-aut w-full max-w-xs" name="docsUrl" onChange={handleInput} />
<label className="label">
<span className="label-text">Description of Certifying Activity</span>
</label>
<textarea placeholder="A protocol that mints and sells photos of all turtles that are rehabilitated at our facilities" className="textarea textarea-bordered" style={{height: "90px"}} name="description" onChange={handleInput} />

<br></br>
<button className="btn btn-accent" onClick={writeAsync} >
Create Badge
</button>
</div>

</div>
</>

 
  );
  
};


