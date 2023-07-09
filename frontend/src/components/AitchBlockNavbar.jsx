import React from "react";
import Image from "next/image";
import Link from "next/link";
import logo1 from "../images/logoD.png";

const AitchBlockNavbar = () => {
  return (
    <div className="w-full flex justify-between text-[#E3F2FD] font-semibold py-4 px-24 top-0 left-0 right-0 z-20">
      <div>
        <Link href="/">
          <Image src={logo1} width={200} alt="Picture of the author" />
        </Link>
      </div>
      <div className="flex gap-48 text-[#02265d]">
        <div className="flex gap-4 justify-center justify-items-center mt-1 text-lg">
          <Link
            className=" bg-[#02265d] text-[#E3F2FD] z-10 text-lg font-semibold hover:-translate-y-px py-2 px-6 ml-20 rounded-lg"
            href="/Launchpad"
          >
            Launch App
          </Link>
        </div>
      </div>
    </div>
  );
};

export default AitchBlockNavbar;
