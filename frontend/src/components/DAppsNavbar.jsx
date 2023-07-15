import React from "react";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import Image from "next/image";
import Link from "next/link";
import logo1 from "../images/logoD.png";

const DAppsNavbar = () => {
  return (
    <div className="w-full flex justify-between text-[#E3F2FD] font-semibold py-4 px-24 top-0 left-0 right-0 z-10">
      <div>
        <Link href="/">
          <Image src={logo1} width={200} alt="Picture of the author" />
        </Link>
      </div>
      <div className="flex gap-48 text-[#02265d]">
        <div className="flex gap-4 justify-center justify-items-center mt-1 text-lg">
          <Link
            className=" hover:bg-[#edf1f8] font-bold bg-white px-1 rounded-lg m-auto"
            href="/Blockchain"
          >
            <button>
              <svg
                className="w-3.5 h-3.5 ml-2"
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
                  d="M1 5h12M1 5l4-4m-4 4l4 4"
                />
              </svg>
            </button>
            Aitch Block
          </Link>
        </div>
        <ConnectButton />
      </div>
    </div>
  );
};

export default DAppsNavbar;
