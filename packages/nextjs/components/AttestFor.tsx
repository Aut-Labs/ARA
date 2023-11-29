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
export const AttestForUser = () => {
  const isLocalNetwork = getTargetNetwork().id === hardhat.id;


  // let createArgs: {name: string, targetContract: `0x${string}`, functionSelector: string, chainID: number, logoUrl: string, docsUrl: string, description: string }

  const [formData, setFormData] = useState({

    userAddressAttestee: "",
    attestationId: "",
    isCheced: false
  });

  const handleInput = (e: any) => {
    const fieldName = e.target.name;
    const fieldValue = e.target.value;
  
    setFormData((prevState) => ({
      ...prevState,
      [fieldName]: fieldValue
    }));
  }

  const { writeAsync, isLoading, isMining }  = useScaffoldContractWrite({
    contractName: "AutAttest",
    functionName: "onChainAttestFor",
    args: [
      `0x${formData.userAddressAttestee.slice(2)}`,
      BigInt(formData.attestationId)
    ],
    blockConfirmations: 1,
    onBlockConfirmation: txnReceipt => {
      console.log("Transaction blockHash", txnReceipt.blockHash);
    }
  })

  const attestThis = () => { 
    writeAsync();
  }

  const checkThis = () => { 

  }


  return (
<>
<div className="createFormArea" id="create-form">

<div className="form-control w-full max-w-xs">
<h4 className="text text-5xl">Attest For</h4>
<br />
<label className="label">
<h3 className="label-text">Attestation ID</h3>
</label>
<input type="text" placeholder="Minted Turtle NFT" className="input input-bordered input-info info-aut w-full max-w-xs" name="attestationId" onChange={handleInput} />
<label className="label">
<span className="label-text">User Address</span>
</label>
<input type="text" placeholder="0x2aa903a6dE876d6f6b8a156b96F8370f824Cd8AB" className="input input-bordered input-info info-aut w-full max-w-xs" name="userAddressAttestee" onChange={handleInput}  />
<label className="label">
<span className="label-text">Function Selector</span>
</label>

<br></br>
<button className="btn btn-accent" onClick={formData.isCheced ? attestThis : checkThis } >
{formData.isCheced ?  <p>Attest</p> : <p>Check</p> }
</button>
</div>

</div>
</>

 
  );
  
};


