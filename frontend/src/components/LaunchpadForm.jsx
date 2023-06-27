import React from "react";
import { ethers } from "ethers";
import { useState } from "react";
import {
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
} from "wagmi";
import FactoryAbi from "../API/Factory.json";
import AitchAbi from "../API/Aitch.json";
import Addresses from "../API/addresses.json";
import { Box, TextField } from "@mui/material";

const LaunchpadForm = () => {
  const aitchAddress = Addresses.aitchAddress;
  const factoryAddress = Addresses.factoryAddress;

  const [tokenAddress, setTokenAddress] = useState("");
  const [tokenName, setTokenName] = useState("");
  const [tokenAmount, setTokenAmount] = useState();

  const { config: approveConfig } = usePrepareContractWrite({
    address: aitchAddress,
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
  });

  const { config: createLaunchpadConfig } = usePrepareContractWrite({
    address: factoryAddress,
    abi: FactoryAbi,
    functionName: "CreateLaunchpad",
    args: [
      tokenAddress ?? "",
      tokenName ?? "",
      ethers.parseEther(tokenAmount ? String(tokenAmount) : "0"),
      aitchAddress,
    ],
  });
  const {
    data: createLaunchpadData,
    isLoading: createLaunchpadIsLoading,
    isSuccess: createLaunchpadIsSuccess,
    write,
  } = useContractWrite(createLaunchpadConfig);
  const { data, isError, isLoading } = useWaitForTransaction({
    hash: createLaunchpadData?.hash,
  });

  return (
    <div>
      <div>{tokenName}</div>
      <Box
        component="form"
        sx={{
          "& .MuiTextField-root": { m: 1, width: "25ch" },
        }}
        noValidate
        autoComplete="off"
      >
        <div className=" grid grid-cols-1 my-12">
          <div>
            <TextField required id="outlined-required" label="Company Name" />
            <TextField required id="outlined-required" label="Owner" />
          </div>
          <div className="text-[#02265d]">
            <TextField required id="outlined-required" label="Website" />
            <TextField
              required
              id="outlined-required"
              label="Email"
              type="email"
            />
          </div>
          <div>
            <TextField
              required
              id="outlined-required"
              label="Token Name"
              value={tokenName}
              onChange={(e) => {
                setTokenName(e.target.value);
              }}
            />
            <TextField
              required
              id="outlined-required"
              label="Token Address"
              defaultValue="0x687.....8976"
              value={tokenAddress}
              onChange={(e) => {
                setTokenAddress(e.target.value);
              }}
            />
          </div>
          <div>
            <TextField
              required
              id="outlined-required"
              label="Token Supply"
              type="number"
              value={tokenAmount}
              onChange={(e) => {
                setTokenAmount(e.target.value);
              }}
            />
            <TextField
              required
              id="outlined-required"
              type="file"
              defaultValue="0x687.....8976"
            />
          </div>
        </div>
      </Box>
    </div>
  );
};

export default LaunchpadForm;
