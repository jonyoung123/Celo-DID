const hre = require("hardhat");
// const { ethers } = require("hardhat");

async function main() {
  // const [sender, receiver] = await ethers.getSigners();
  // const senderBalance = await ethers.provider.getBalance(sender.address); // Get the balance of the sender account

  // const value = senderBalance.toHexString(); // Convert BigNumber to hex string

  // // Transfer some funds to the deployer account
  // const tx = await ethers.provider.sendTransaction({
  //   to: receiver.address,
  //   value: value // 1 ETH
  // });

  // console.log(`Transaction hash: ${tx.hash}`);

  const gasPrice = hre.ethers.utils.parseUnits("10", "gwei"); // Adjust the gas price as needed
  const gasLimit = 2000000;

  console.log(gasPrice);
  console.log( await hre.ethers.provider.getSigner().getAddress());
  

  const CeloDIDRegistry = await hre.ethers.getContractFactory("CeloDIDRegistry");
  const celoDIDRegistry = await CeloDIDRegistry.deploy({gasPrice, gasLimit});

  await celoDIDRegistry.deployed();

  console.log("CeloDIDRegistry deployed to:", celoDIDRegistry.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });