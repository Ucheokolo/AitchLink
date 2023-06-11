import React from "react";
import DAppsNavbar from "@/components/DAppsNavbar";
import styles from "../styles/styles.module.css";
import Image from "next/image";
import pic from "../images/blk1.png";

const Blockchain = () => {
  return (
    <div className={styles.blockchainbg}>
      <DAppsNavbar />
      <div className="px-24">
        <div className="flex border-solid border-2 rounded-lg border-indigo-600 h-94">
          <div>
            <Image src={pic} width={800} alt="Picture of the author" />
          </div>
          <div className="w-3/6">
            <h1>Aitch Block</h1>
            <p>
              AitchBlock is an AitchLink Decentralized application at the
              forefront of the blockchain revolution, offering comprehensive
              crypto launchpad and exchange, and peer to peer services. Our aim
              is to establish ourselves as a trusted platform that bridges the
              gap between traditional business operations and the innovative
              potential of blockchain technology.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Blockchain;
