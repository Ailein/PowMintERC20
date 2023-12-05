import { ethers } from "hardhat";

async function main() {
  const Token = await ethers.getContractFactory("PowERC20");
  const token = await Token.deploy(
    "0xabcde",
    ethers.utils.formatEther("1000"),
    "Pow ERC20",
    "POE",
    ethers.utils.formatEther("21000000")
  );

  const tx = await token.deployed();

  console.log(`deployed to ${tx.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
