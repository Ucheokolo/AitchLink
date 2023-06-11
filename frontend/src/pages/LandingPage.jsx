import React from "react";
import styles from "../styles/styles.module.css";
import Image from "next/image";
import bg1 from "../images/bg1.png";

const LandingPage = () => {
  return (
    <div className="">
      <div className={styles.homebg}>
        <div className="mt-12 ml-6">
          <Image src={bg1} width={200} alt="Picture of the author" />
        </div>
        <div className="">
          <h1 className="mt-24 text-left text-7xl">
            Automate Your Future with Blockchain
          </h1>
          <p className="text-2xl text-left mt-5">
            Transparency, Security and Efficiency
          </p>
        </div>
      </div>
    </div>
  );
};

export default LandingPage;
