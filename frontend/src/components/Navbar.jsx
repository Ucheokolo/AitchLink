import React from "react";
import Link from "next/link";
import { useState } from "react";
import Image from "next/image";
import logo from "../images/logoB.png";
import { Router } from "next/router";

const Navbar = () => {
  const [navbar, setNavbar] = useState(false);
  return (
    <nav className="w-full bg-[#02265d] text-[#E3F2FD] p-4 top-0 left-0 right-0 z-10">
      <div className="flex justify-between">
        <div>
          <Link href="/">
            <Image src={logo} width={200} alt="Picture of the author" />
          </Link>
        </div>
        <div className="flex gap-3 lg:max-w-7xl md:items-center md:flex ">
          <Link href="/">Home</Link>
          <Link href="">About us</Link>
          <Link href="">Services</Link>
          <Link
            className=" bg-[#E3F2FD] text-[#02265d] text-lg font-bold hover:-translate-y-px py-2 px-6 ml-20 rounded-lg"
            href="/Blockchain"
          >
            <button>
              <svg
                className="w-4 h-4 mr-2 -ml-1 text-[#626890]"
                aria-hidden="true"
                focusable="false"
                data-prefix="fab"
                data-icon="ethereum"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 320 512"
              >
                <path
                  fill="currentColor"
                  d="M311.9 260.8L160 353.6 8 260.8 160 0l151.9 260.8zM160 383.4L8 290.6 160 512l152-221.4-152 92.8z"
                ></path>
              </svg>
            </button>
            Aitch Block
          </Link>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
