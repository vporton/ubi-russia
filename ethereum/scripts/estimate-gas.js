// We require the Buidler Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
// When running the script with `buidler run <script>` you'll find the Buidler
// Runtime Environment's members available in the global scope.
const bre = require("@nomiclabs/buidler");

async function performTransaction(contract, user, method, ...args) {
  const gas = await contract.connect(user).estimateGas[method](...args, { gasLimit: 1000000 });
//  await contract.connect(user)[method](...args);
  return gas;
}

async function main() {
  const [deployer, server, programmer, user1, user2] = await ethers.getSigners();

  const GasHolder = await ethers.getContractFactory("GasHolder");
  const gasHolder = await GasHolder.deploy(await server.getAddress(), await programmer.getAddress(), 18);
  await gasHolder.deployed();
  const RegUBI = await ethers.getContractFactory("RUSREG");
  const regUBI = await RegUBI.deploy(await programmer.getAddress(), gasHolder.address);
  const BirUBI = await ethers.getContractFactory("RUSBIR");
  const birUBI = await BirUBI.deploy(await programmer.getAddress(), gasHolder.address);
  await regUBI.deployed();
  await birUBI.deployed();

  await user1.sendTransaction({to: gasHolder.address, value: ethers.utils.parseEther("1.0")});
  await user2.sendTransaction({to: gasHolder.address, value: ethers.utils.parseEther("1.0")});
  // console.log(ethers.utils.formatEther(await gasHolder.balances(await user1.getAddress())));

  const gas1 = await performTransaction(gasHolder, server, 'setAccounts', await user1.getAddress(), [regUBI.address], [1000], [1], [false], true);
  console.log(ethers.utils.formatEther(gas1));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });