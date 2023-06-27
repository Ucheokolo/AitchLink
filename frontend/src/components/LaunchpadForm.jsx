import React from "react";
import { ethers } from "ethers";
import { useState } from "react";
import {
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
} from "wagmi";
import FactoryAbi from "../API/Factory.json";
import Addresses from "../API/addresses.json";
import { Box, TextField } from "@mui/material";

const LaunchpadForm = () => {
  const aitchAddress = Addresses.aitchAddress;

  const [tokenAddress, setTokenAddress] = useState("");
  const [tokenName, setTokenName] = useState("");
  const [tokenAmount, setTokenAmount] = useState();

  const { config: createLaunchpadConfig } = usePrepareContractWrite({
    address: Addresses.factoryAddress,
    abi: FactoryAbi,
    functionName: "CreateLaunchpad",
    args: [
      tokenAddress,
      tokenName,
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
            <TextField required id="outlined-required" label="Token Name" />
            <TextField
              required
              id="outlined-required"
              label="Token Address"
              defaultValue="0x687.....8976"
            />
          </div>
          <div>
            <TextField
              required
              id="outlined-required"
              label="Token Supply"
              type="number"
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
