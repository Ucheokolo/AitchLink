import React from "react";
import { ethers } from "ethers";
import { useState } from "react";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import {
  useContractRead,
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
  useAccount,
} from "wagmi";
import FactoryAbi from "../API/Factory.json";
import AitchAbi from "../API/Aitch.json";
import Addresses from "../API/addresses.json";
import { Box, TextField, Button } from "@mui/material";
import main from "./index.mjs";

const LaunchpadForm = () => {
  ///////////////////////////
  //////// Variables ///////
  /////////////////////////

  const aitchAddress = Addresses.aitchAddress;
  const factoryAddress = Addresses.factoryAddress;

  //// form Details ////
  const [name, setName] = useState("");
  const [owner, setOwner] = useState("");
  const [website, setWebsite] = useState("");
  const [description, setDescription] = useState("");
  const [launchpadImage, setImage] = useState();

  const [tokenName, setTokenName] = useState("");
  const [tokenAddress, setTokenAddress] = useState("");
  const [tokenAmount, setTokenAmount] = useState();
  const [cid, setCid] = useState("");

  const [launchTokenAllowance, setAllowance] = useState();
  const [approveState, setApproveState] = useState(false);
  const [showRegistration, setShowRegistration] = useState(false);

  const {
    address: user,
    isConnecting: userIsConnecting,
    isDisconnected: userIsDisconnected,
  } = useAccount();

  //////////////////////////////
  //////// Integration ////////
  ////////////////////////////
  const {
    data: allowanceData,
    isError: isErrorAllowance,
    isLoading: isLoadingAllowance,
  } = useContractRead({
    address: tokenAddress,
    abi: AitchAbi,
    functionName: "allowance",
    args: [user, factoryAddress],
    watch: true,
    onSuccess(allowanceData) {
      console.log("Success", Number(allowanceData));
      setAllowance(Number(allowanceData));
    },
  });

  const { config: approveConfig } = usePrepareContractWrite({
    address: tokenAddress,
    abi: AitchAbi,
    functionName: "approve",
    args: [
      factoryAddress,
      ethers.parseEther(tokenAmount ? String(tokenAmount) : "0"),
    ],
  });
  const {
    data: approveData,
    isLoading: isLoadingApprove,
    isSuccess: isSuccessApprove,
    write: approve,
  } = useContractWrite(approveConfig);
  const {
    data: DataApprove,
    isError: isErrorApprove,
    isLoading: ApproveLoading,
  } = useWaitForTransaction({
    hash: approveData?.hash,
    onSuccess(result) {
      toast.success("Approval Granted, CreateLaunchpad Initiated");
      // handleUpload?.();
    },
    onError(error) {
      toast.error(`ERROR:`, error.slice(0, 20));
    },
  });

  const { config: createLaunchpadConfig } = usePrepareContractWrite({
    address: factoryAddress,
    abi: FactoryAbi,
    functionName: "CreateLaunchpad",
    args: [
      tokenAddress ?? "",
      tokenName ?? "",
      cid,
      ethers.parseEther(tokenAmount ? String(tokenAmount) : "0"),
      aitchAddress,
    ],
  });
  const {
    data: createLaunchpadData,
    isLoading: createLaunchpadIsLoading,
    isSuccess: createLaunchpadIsSuccess,
    write: CreateLaunchpad,
  } = useContractWrite(createLaunchpadConfig);
  const { data, isError, isLoading } = useWaitForTransaction({
    hash: createLaunchpadData?.hash,
  });

  //////////////////////////////
  //////// Functions //////////
  ////////////////////////////

  const handleNameChange = (e) => {
    setName(e.target.value);
  };

  const handleOwnerChange = (e) => {
    setOwner(e.target.value);
  };

  const handleWebChange = (e) => {
    setWebsite(e.target.value);
  };

  const handleDescription = (e) => {
    setDescription(e.target.value);
  };

  const handleTokenNameChange = (e) => {
    setTokenName(e.target.value);
  };

  const handleTokenAddressChange = (e) => {
    setTokenAddress(e.target.value);
  };

  const handleTokenAmountChange = (e) => {
    setTokenAmount(e.target.value);
  };

  const handleImageChange = (e) => {
    setImage(e.target.files[0]);
  };

  // Submit functions
  const toggleRegister = () => {
    setShowRegistration(!showRegistration);
  };

  const handleApprove = async (e) => {
    e.preventDefault();
    approve?.();
    const result = await main(
      launchpadImage,
      name,
      description,
      owner,
      website,
      tokenName,
      tokenAddress,
      tokenAmount
    );
    setCid(result.ipnft);
    console.log(cid);
  };
  const handleUpload = () => {
    // e.preventDefault();
    CreateLaunchpad?.();
  };

  // useEffect(() => {
  //   if (DataApprove) {
  //     // console.log(DataApprove);
  //     setApproveState(true);
  //   }
  // }, [DataApprove]);

  return (
    <div>
      <button
        onClick={toggleRegister}
        className=" w-32 bg-gradient-to-r from-[#dc2626] to-[#450a0a] text-[#ffff] font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center"
      >
        Register
        <svg
          class="w-3.5 h-3.5 ml-2"
          aria-hidden="true"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 14 10"
        >
          <path
            stroke="currentColor"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M1 5h12m0 0L9 1m4 4L9 9"
          />
        </svg>
      </button>
      {showRegistration && (
        <Box
          component="form"
          sx={{
            "& .MuiTextField-root": { m: 1, width: "25ch" },
          }}
          noValidate
          autoComplete="off"
          onSubmit={(e) => {
            e.preventDefault();
            ethers.parseEther(tokenAmount ? String(tokenAmount) : "0") >
            String(launchTokenAllowance)
              ? handleApprove(e)
              : handleUpload(e);
          }}
        >
          <div className=" grid grid-cols-1 mt-12">
            {tokenName}: {launchTokenAllowance}
            <div>
              <TextField
                required
                id="outlined-required"
                label="Company Name"
                value={name}
                onChange={handleNameChange}
              />
              <TextField
                required
                id="outlined-required"
                label="Owner"
                value={owner}
                onChange={handleOwnerChange}
              />
            </div>
            <div className="text-[#02265d]">
              <TextField
                required
                id="outlined-required"
                label="Website"
                value={website}
                onChange={handleWebChange}
              />
              <TextField
                required
                id="outlined-required"
                label="Email"
                type="email"
                value={description}
                onChange={handleDescription}
              />
            </div>
            <div>
              <TextField
                required
                id="outlined-required"
                label="Token Name"
                value={tokenName}
                onChange={handleTokenNameChange}
              />
              <TextField
                required
                id="outlined-required"
                label="Token Address"
                defaultValue="0x687.....8976"
                value={tokenAddress}
                onChange={handleTokenAddressChange}
              />
            </div>
            <div>
              <TextField
                required
                id="outlined-required"
                label="Token Supply"
                type="number"
                value={tokenAmount}
                onChange={handleTokenAmountChange}
              />
              <TextField
                required
                id="outlined-required"
                type="file"
                onChange={handleImageChange}
              />
            </div>
          </div>
          <div>
            {ethers.parseEther(tokenAmount ? String(tokenAmount) : "0") >
            String(launchTokenAllowance) ? (
              <button
                type="submit"
                className=" w-32 bg-[#02265d] text-[#ffff] text-center rounded-md p-2 mt-4 mb-8"
              >
                Approve
              </button>
            ) : (
              <button
                type="submit"
                className=" w-32 bg-[#02265d] text-[#ffff] text-center rounded-md p-2 mt-4 mb-8"
              >
                Upload Details
              </button>
            )}
            <ToastContainer />
          </div>
        </Box>
      )}
    </div>
  );
};

export default LaunchpadForm;
// https://ipfs.io/ipfs/bafyreigstetoazp4d4gk37xfyaaxuyld4dtssf4d3vacw4mrprererr4rm/metadata.json

{
  /* )} */
}
{
  /* <button
  type="submit"
  className=" w-32 bg-[#02265d] text-[#ffff] text-center rounded-md p-2 mt-4 mb-8"
>
  {ethers.parseEther(tokenAmount ? String(tokenAmount) : "0") >
  String(launchTokenAllowance)
    ? "Approve"
    : "Upload Details"}
</button> */
}
