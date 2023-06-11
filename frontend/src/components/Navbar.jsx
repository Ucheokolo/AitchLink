import React from "react";
import Link from "next/link";
import { useState } from "react";
import Image from "next/image";
import logo from "../images/logoB.png";

const Navbar = () => {
  const [navbar, setNavbar] = useState(false);
  return (
    <nav className="w-full bg-[#02265d] text-[#E3F2FD] p-4 top-0 left-0 right-0 z-10">
      <div className="flex justify-between">
        <div>
          <Link href="/">
            <Image src={logo} width={150} alt="Picture of the author" />
          </Link>
        </div>
        <div className="flex gap-3 lg:max-w-7xl md:items-center md:flex ">
          <Link href="/">Home</Link>
          <Link href="">About us</Link>
          <Link href="">Services</Link>
          <Link
            className=" bg-[#E3F2FD] text-[#02265d] px-2 ml-20 rounded-lg"
            href="/Blockchain"
          >
            Launch App
          </Link>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
