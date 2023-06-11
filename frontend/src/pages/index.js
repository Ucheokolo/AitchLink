import Image from "next/image";
import { Inter } from "next/font/google";
// import styles from "../styles/styles.module.css";
import Navbar from "@/components/Navbar";
import LandingPage from "./LandingPage";

const inter = Inter({ subsets: ["latin"] });

export default function Home() {
  return (
    <div>
      <Navbar />
      <LandingPage />
    </div>
  );
}
