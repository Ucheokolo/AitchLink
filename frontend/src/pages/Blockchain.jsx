import React from "react";
import DAppsNavbar from "@/components/DAppsNavbar";
import styles from "../styles/styles.module.css";
import Image from "next/image";
import pic from "../images/blk1.png";
import p2p from "../images/p2p.png";
import lp from "../images/lp.png";
import stk from "../images/stk.png";

const Blockchain = () => {
  return (
    <div className={styles.blockchainbg}>
      <div className="h-32 w-32 truncate rounded-full fixed top-6 right-6 bg-white"></div>
      <DAppsNavbar />
      <div className="px-24 relative">
        <div className={styles.sectionBlock}>
          <div>
            <Image src={pic} width={700} alt="Picture of the author" />
          </div>
          <div className="w-3/6 p-6 text-left m-auto">
            <h1 className="font-bold text-6xl">Aitch Block</h1>
            <h3 className="font-semibold text-[#43447e] text-xl pb-6">
              Unlocking Efficiency, Empowering Startups
            </h3>
            <p className="leading-8 text-xl">
              AitchBlock is an AitchLink Decentralized application at the
              forefront of the blockchain revolution, offering comprehensive
              crypto launchpad, exchange, and peer to peer(P2P) services. Our
              aim is to establish ourselves as a trusted platform that bridges
              the gap between traditional business operations and the innovative
              potential of blockchain technology.
            </p>
          </div>
        </div>
        <div className="grid grid-cols-3 gap-4">
          <div className={styles.services}>
            <div className="flex bg-[#e2f0f3] rounded-2xl m-6">
              <Image src={p2p} width={180} alt="Picture of the author" />
              <h1 className="my-auto text-4xl font-medium">Aitch-Peers</h1>
            </div>
            <p>
              Experience secure and direct peer-to-peer (P2P) transactions with
              AitchLink's P2P Services. Our platform facilitates seamless
              interactions between individuals, enabling trusted and efficient
              exchange of digital assets. By leveraging blockchain technology,
              we ensure transparency, immutability, and enhanced privacy for P2P
              transactions, empowering users to engage in decentralized
              exchanges with confidence.
            </p>
          </div>
          <div className={styles.services}>
            <div className="flex bg-[#e2f0f3] rounded-2xl m-6">
              <Image src={lp} width={150} alt="Picture of the author" />
              <h2 className="my-auto text-4xl font-medium">Aitch-Pad</h2>
            </div>
            <p>
              Discover the potential of crypto projects with AitchLink's
              Launchpad Services. We provide a comprehensive platform for
              promising cryptocurrency ventures, offering fundraising support,
              community engagement tools, and efficient token distribution
              mechanisms. Unlock new opportunities and join the thriving world
              of crypto with our Launchpad Services.
            </p>
          </div>
          <div className={styles.services}>
            <div className="flex  bg-[#e2f0f3] rounded-2xl m-6">
              <Image src={stk} width={150} alt="Picture of the author" />
              <p className="my-auto text-4xl font-medium">Aitch-X</p>
            </div>
            <p>
              Participate in the growth and governance of blockchain networks
              through AitchLink's Stake Services. Stake your digital assets to
              support network consensus and earn rewards. Our platform provides
              a user-friendly interface, comprehensive staking options, and
              secure protocols to enhance your staking experience. Join the
              staking revolution and contribute to the decentralization of
              blockchain networks with AitchLink.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Blockchain;
