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
            className="hover:underline underline-offset-4"
            href="/Launchpad"
          >
            Launchpad
          </Link>
          <Link className="hover:underline underline-offset-4" href="">
            Swap
          </Link>
          <Link className="hover:underline underline-offset-4" href="">
            P2P
          </Link>
        </div>
        <ConnectButton />
      </div>
    </div>
  );
};

export default DAppsNavbar;
