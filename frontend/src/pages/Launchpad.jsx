import React from "react";
import DAppsNavbar from "@/components/DAppsNavbar";
import styles from "../styles/styles.module.css";
import Image from "next/image";
import bg from "../images/lpmbg.png";
import ast from "../images/lpbg.png";

const Launchpad = () => {
  return (
    <div className="min-h-screen bg-gradient-to-r from-[#bbdefb] to-[#e3f2fd] text-[#02265d]">
      <div className="h-32 w-32 truncate rounded-full fixed top-6 right-6 bg-white"></div>
      <div className="fixed right-16 top-20">
        <Image src={ast} width={100} alt="Picture of the author" />
      </div>
      <div className="fixed bottom-28 right-0">
        {/* <Image src={bg} width={400} alt="Picture of the author" /> */}
      </div>
      <DAppsNavbar />
      <div className="px-24 ">
        <div className="w-3/5 border-2">
          <h1 className="font-bold text-4xl">Aitch-Pad</h1>
          <p>Where Innovation Takes Flight</p>
        </div>
      </div>
    </div>
  );
};

export default Launchpad;
