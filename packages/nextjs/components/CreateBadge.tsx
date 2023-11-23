import React from "react";
import Link from "next/link";
import { hardhat } from "viem/chains";
import { getTargetNetwork } from "~~/utils/scaffold-eth";
import {useScaffoldContractWrite} from "~~/hooks/scaffold-eth";
import { off } from "process";
import { EtherscanProvider } from "@ethersproject/providers";
/**
 * Site footer
 */
export const CreateBadgeForm = () => {
  const isLocalNetwork = getTargetNetwork().id === hardhat.id;

 

  let createArgs: [string, bigint, `0x${string}`, bigint, string];


  const setVal = async (offsetS: number,value: string | bigint |`0x${string}` | string) => {
      createArgs[offsetS] = value;
      console.log(createArgs);
      return createArgs;
  } 

  const createBadge = async () => {

  }



  return (

    <div className="createFormArea" id="create-form">

    <div className="form-control w-full max-w-xs">
    <h4 className="text text-5xl">Create Badge</h4>
    <br />
<label className="label">
<h3 className="label-text">Action Description</h3>
</label>
<input type="text" placeholder="Minted Turtle NFT" className="input input-bordered input-info info-aut w-full max-w-xs" onChange={(e) => { setVal(0,e.target.value) }} />
<label className="label">
<span className="label-text">Target Contract Address</span>
</label>
<input type="text" placeholder="0x2aa903a6dE876d6f6b8a156b96F8370f824Cd8AB" className="input input-bordered input-info info-aut w-full max-w-xs" onChange={(e) => {  setVal(1,BigInt(e.target.value)) } }  />
<label className="label">
<span className="label-text">Function Selector</span>
</label>
<input type="text" placeholder="transferTokenTo(uint256,address)" className="input input-bordered input-info info-aut w-full max-w-xs" onChange={(e) => { setVal(2,`0x${e.target.value}`) }} />
<label className="label">
<span className="label-text">Chain ID</span>
</label>
<input type="text" placeholder={String(getTargetNetwork().id)} className="input input-bordered input-info info-aut w-full max-w-xs" value={getTargetNetwork().id} onChange={(e) => {setVal(3,BigInt(e.target.value)) }} />
<label className="label">
<span className="label-text">Logo url</span>
</label>
<input type="text" placeholder="http://google.com/logo.png" className="input input-bordered input-info info-aut w-full max-w-xs" onChange={(e) => { setVal(4,e.target.value) }} />
<label className="label">
<span className="label-text">Link to protocol documentation</span>
</label>
<input type="text" placeholder="http://turtle-protocol.xyz/docs/contracts" className="input input-bordered input-info info-aut w-full max-w-xs" onChange={(e) => { setVal(4,e.target.value) }} />
<label className="label">
<span className="label-text">Description of Certifying Activity</span>
</label>
<textarea placeholder="A protocol that mints and sells photos of all turtles that are rehabilitated at our facilities" className="textarea textarea-bordered" style={{height: "90px"}} />

<br></br>
<button className="btn btn-accent" onClick={ createBadge } >
    Create Badge
</button>
  </div>

</div>
 
  );
  
};


