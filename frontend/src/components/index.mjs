import { NFTStorage, File } from "nft.storage";

const NFT_STORAGE_KEY =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweEI2MTUyNTJDOTdDYzViOTE2YjhBYzE2NTRmQWJhQmREZTlkMjM2MUMiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTY4ODA3Njk0MjIyMSwibmFtZSI6IkFpdGNoIn0.3URD36tbKStvJ0w7aOxrKPr5GU0zgHobHS7Y44h-Vo8";

async function StoreNFT(
  image,
  name,
  description,
  onwer,
  website,
  tokenName,
  tokenAddr,
  tokenAmount
) {
  const nftStorage = new NFTStorage({ token: NFT_STORAGE_KEY });

  return nftStorage.store({
    image,
    name,
    description,
    onwer,
    website,
    tokenName,
    tokenAddr,
    tokenAmount,
  });
}

async function main(
  image,
  name,
  description,
  onwer,
  website,
  tokenName,
  tokenAddr,
  tokenAmount
) {
  const result = await StoreNFT(
    image,
    name,
    description,
    onwer,
    website,
    tokenName,
    tokenAddr,
    tokenAmount
  );
  console.log(result);
  return result;
}

export default main;
