const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory(
      "ChainBattles"
    );

    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract Deployed to", nftContract.address);
    process.exit(0);
  } catch (e) {
    console.log(e);
    process.exit(1);
  }
};

main();
