import "@/styles/globals.css";
import "@rainbow-me/rainbowkit/styles.css";
import {
  getDefaultWallets,
  RainbowKitProvider,
  lightTheme,
} from "@rainbow-me/rainbowkit";
import { configureChains, createConfig, WagmiConfig } from "wagmi";
import { mainnet, polygon, optimism, arbitrum, sepolia } from "wagmi/chains";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";
import { jsonRpcProvider } from "wagmi/providers/jsonRpc";

const { chains, publicClient } = configureChains(
  [mainnet, polygon, optimism, arbitrum, sepolia],
  [
    alchemyProvider({
      apiKey:
        "https://eth-sepolia.g.alchemy.com/v2/RI7ZDSFe_aVe-sdiz-Qi5yCARSdG_IHV",
    }),
    publicProvider(),
  ]
);

// const { chains, provider } = configureChains(
//   [mainnet, polygon, optimism, arbitrum, sepolia],
//   [
//     jsonRpcProvider({
//       rpc: (chain) => ({
//         http: "https://eth-sepolia.g.alchemy.com/v2/hJFM1b2zVYTp1KoGenn_DaTqmpuEqH5Z",
//         WebSocket:
//           "wss://eth-sepolia.g.alchemy.com/v2/hJFM1b2zVYTp1KoGenn_DaTqmpuEqH5Z",
//       }),
//     }),
//   ]
// );

const { connectors } = getDefaultWallets({
  appName: "My RainbowKit App",
  projectId: "YOUR_PROJECT_ID",
  chains,
});

const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
});

export default function App({ Component, pageProps }) {
  return (
    <WagmiConfig config={wagmiConfig}>
      <RainbowKitProvider
        chains={chains}
        modalSize="compact"
        theme={lightTheme({
          accentColor: "#02265d",
          accentColorForeground: "white",
          borderRadius: "medium",
        })}
      >
        <Component {...pageProps} />
      </RainbowKitProvider>
    </WagmiConfig>
  );
}
