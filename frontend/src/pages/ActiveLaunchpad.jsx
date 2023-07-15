import React from "react";
import { useState, useEffect } from "react";
import { useContractRead } from "wagmi";
import FactoryAbi from "../API/Factory.json";
import Addresses from "../API/addresses.json";
import InputAddress from "@/components/InputAddress";
import { Content } from "next/font/google";

const ActiveLaunchpad = () => {
  const factoryAddr = Addresses.factoryAddress;
  const nativeToken = Addresses.aitchAddress;
  const [launchpadLength, setLaunchpadLength] = useState();
  const [addressArray, setAddressArray] = useState([]);
  const [launchpadDetails, setlaunchpadDetails] = useState([]);
  const [launchpadAddr, setlaunchpadAddr] = useState("");

  const {
    data: sizeData,
    isError: isErrorSize,
    isLoading: isLoadingSize,
  } = useContractRead({
    address: factoryAddr,
    abi: FactoryAbi,
    functionName: "getLaunchpadSize",
    onSuccess(sizeData) {
      console.log("Success", Number(sizeData));
      setLaunchpadLength(Number(sizeData));
    },
  });

  const {
    data: getAllAddressesData,
    isError: isErrorGetAllAddresses,
    isLoading: isLoadingGetAllAddresses,
  } = useContractRead({
    address: factoryAddr,
    abi: FactoryAbi,
    functionName: "getAllAddresses",
    onSuccess(getAllAddressesData) {
      console.log("Success", getAllAddressesData);
      setAddressArray(getAllAddressesData);
    },
  });

  useEffect(() => {
    const getAddressDetails = async () => {
      for (let i = 0; i < launchpadLength; i++) {
        const currentAddress = addressArray[i];
        try {
          const getLauchpadDetailsData = await useContractRead({
            address: factoryAddr,
            abi: FactoryAbi,
            functionName: "getLauchpadDetails",
            args: [currentAddress],
          });
          console.log("Success", getLauchpadDetailsData);
          setlaunchpadDetails((prevDetails) => [
            ...prevDetails,
            getLauchpadDetailsData,
          ]);
        } catch (error) {
          console.error("Error", error);
        }
      }
    };

    getAddressDetails();
  }, [launchpadLength, addressArray]);

  return (
    <div>
      <div>{launchpadLength}</div>
      <div>
        {addressArray.map((content, index) => (
          <div key={index}>{content}</div>
        ))}
      </div>
      <div className=" bg-slate-200 border-cyan-600">
        <div>{launchpadDetails.Name}</div>
        <div>{launchpadDetails.LaunchPadcreator}</div>
      </div>
    </div>
  );
};

export default ActiveLaunchpad;

// getLauchpadDetails;
// getAllAddresses;
// getLaunchpadSize;
