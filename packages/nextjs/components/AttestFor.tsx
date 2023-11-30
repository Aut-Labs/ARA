// import React, { useState } from "react";
// import Link from "next/link";
// import { Chain, CovalentClient } from "@covalenthq/client-sdk";
// import { Transaction } from "@covalenthq/client-sdk";
// import { EtherscanProvider } from "@ethersproject/providers";
// import { create } from "domain";
// import { off } from "process";
// import { numberToBytes } from "viem";
// import { hardhat } from "viem/chains";
// import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";
// import { getTargetNetwork } from "~~/utils/scaffold-eth";

// /**
//  * Site footer
//  */
// export const AttestForUser = () => {
//   const isLocalNetwork = getTargetNetwork().id === hardhat.id;
//   const chainName = getTargetNetwork().sourceId;

//   // let createArgs: {name: string, targetContract: `0x${string}`, functionSelector: string, chainID: number, logoUrl: string, docsUrl: string, description: string }

//   const [formData, setFormData] = useState({
//     userAddressAttestee: "",
//     attestationId: "",
//     isCheced: false,
//   });

//   const handleInput = (e: any) => {
//     const fieldName = e.target.name;
//     const fieldValue = e.target.value;

//     setFormData(prevState => ({
//       ...prevState,
//       [fieldName]: fieldValue,
//     }));
//   };

//   const { writeAsync, isLoading, isMining } = useScaffoldContractWrite({
//     contractName: "AutAttest",
//     functionName: "onChainAttestFor",
//     args: [`0x${formData.userAddressAttestee.slice(2)}`, BigInt(formData.attestationId)],
//     blockConfirmations: 1,
//     onBlockConfirmation: txnReceipt => {
//       console.log("Transaction blockHash", txnReceipt.blockHash);
//     },
//   });

//   const attestThis = () => {
//     writeAsync();
//   };

//   const checkThis = async () => {
//     const client = new CovalentClient(String(process.env.COVALENT_API_KEY)); // Replace with your Covalent API key.
//     const currentChain: Chain = getTargetNetwork().name as Chain;
//     const data: Transaction[] = [];
//     try {
//       const transactions = await client.TransactionService.getAllTransactionsForAddress(
//         currentChain,
//         formData.userAddressAttestee,
//       );
//       for await (const transaction of transactions) {
//         if (
//           transaction.from_address === formData.userAddressAttestee &&
//           transaction.to_address === "0x2aa903a6dE876d6f6b8a156b96F8370f824Cd8AB" &&
//           transaction.successful === true &&
//           transaction.explorers
//         )
//           data.push(transaction);
//       }
//     } catch (error) {
//       console.error("Error fetching transactions:", error);
//     }
//   };

//   return (
//     <>
//       <div className="createFormArea" id="create-form">
//         <div className="form-control w-full max-w-xs">
//           <h4 className="text text-5xl">Attest For</h4>
//           <br />
//           <label className="label">
//             <h3 className="label-text">Attestation ID</h3>
//           </label>
//           <input
//             type="text"
//             placeholder="Minted Turtle NFT"
//             className="input input-bordered input-info info-aut w-full max-w-xs"
//             name="attestationId"
//             onChange={handleInput}
//           />
//           <label className="label">
//             <span className="label-text">User Address</span>
//           </label>
//           <input
//             type="text"
//             placeholder="0x2aa903a6dE876d6f6b8a156b96F8370f824Cd8AB"
//             className="input input-bordered input-info info-aut w-full max-w-xs"
//             name="userAddressAttestee"
//             onChange={handleInput}
//           />
//           <label className="label">
//             <span className="label-text">Function Selector</span>
//           </label>

//           <br></br>
//           <button className="btn btn-accent" onClick={formData.isCheced ? attestThis : checkThis}>
//             {formData.isCheced ? <p>Attest</p> : <p>Check</p>}
//           </button>
//         </div>
//       </div>
//     </>
//   );
// };
