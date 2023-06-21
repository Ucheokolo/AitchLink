import React from "react";
import { useState } from "react";
import DAppsNavbar from "@/components/DAppsNavbar";
import styles from "../styles/styles.module.css";
import Image from "next/image";
import bg from "../images/lpmbg.png";
import ast from "../images/lpbg.png";
import factoryAbi from "../API/Factory.json";
import { useContractRead } from "wagmi";

const Launchpad = () => {
  const [launchpadId, setId] = useState(0);
  const {
    data: launchpadData,
    isError: launchpadIsError,
    isLoading: launchpadIsLoading,
  } = useContractRead({
    address: "0x464b571265002aE4914Ec813f90d04D6f1770B5C",
    abi: factoryAbi,
    functionName: "getLauchpadDetails",
    args: [launchpadId],
    onSuccess: (data) => {
      console.log("Success", launchpadData);
      setId(data);
      console.log(data);
    },
  });

  return (
    <div className="min-h-screen bg-gradient-to-r from-[#bbdefb] to-[#e3f2fd] text-[#02265d]">
      <div className="h-32 w-32 truncate rounded-full fixed top-6 right-6 bg-white"></div>
      <div className="fixed right-16 top-20">
        <Image src={ast} width={100} alt="Picture of the author" />
      </div>
      <div className="fixed bottom-28 right-0">
        <Image src={bg} width={500} alt="Picture of the author" />
      </div>
      <DAppsNavbar />
      <div className="px-24 ">
        <div className="w-3/5 bg-[#ffffff1a] z-10 rounded-lg border-solid border-1 border-[#ffffffc4] backdrop-blur-lg shadow-lg shadow-[#0a0a0a40]">
          <h1 className="font-bold text-4xl">Aitch-Pad</h1>
          <p>Where Innovation Takes Flight</p>
        </div>
      </div>
    </div>
  );
};

export default Launchpad;
