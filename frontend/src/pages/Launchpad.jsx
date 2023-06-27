import React from "react";
import { useState } from "react";
import DAppsNavbar from "@/components/DAppsNavbar";
import styles from "../styles/styles.module.css";
import Image from "next/image";
import bg from "../images/lpmbg.png";
import ast from "../images/lpbg.png";
import LaunchpadForm from "@/components/LaunchpadForm";

const Launchpad = () => {
  return (
    <div className="min-h-screen bg-gradient-to-r from-[#90caf9] to-[#bedaee] text-[#02265d]">
      <div className="h-32 w-32 truncate rounded-full fixed top-6 right-6 bg-white">
        <h1></h1>
      </div>
      <div className="fixed right-10 top-20">
        <Image src={ast} width={100} alt="Picture of the author" />
      </div>
      <div className="fixed bottom-28 right-0">
        <Image src={bg} width={500} alt="Picture of the author" />
      </div>
      <DAppsNavbar />
      <div className="px-24 flex gap-4">
        <div className=" w-11/12 bg-[#ffffff1a] z-10 rounded-lg border-solid border-1 border-[#ffffffc4] backdrop-blur-lg shadow-lg shadow-[#0a0a0a40]">
          <h1 className="font-bold text-4xl">Aitch-Pad</h1>
          <p>Where Innovation Takes Flight</p>
        </div>
        <div className=" text-center bg-[#ffffff1a] z-10 rounded-lg border-solid border-1 border-[#ffffffc4] backdrop-blur-sm shadow-lg shadow-[#0a0a0a40]">
          <LaunchpadForm />
        </div>
      </div>
    </div>
  );
};

export default Launchpad;
