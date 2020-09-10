// We require the Buidler Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
// When running the script with `buidler run <script>` you'll find the Buidler
// Runtime Environment's members available in the global scope.
const bre = require("@nomiclabs/buidler");

if(bre.network.name == 'buidlerevm') {
  console.log("Refusing to run under BEVM due to https://github.com/nomiclabs/buidler/issues/782\n" +
              "Use `ganache-cli -d` and this script with `--network ganache`");
  process.exit(1);
}

async function performTransaction(contract, user, method, ...args) {
  // const gas = await contract.connect(user).estimateGas[method](...args, { gasLimit: 1000000 }); // gives wrong results on both BEVM and Ganache
  const rx = await contract.connect(user)[method](...args, { gasLimit: 1000000 });
  const gas = (await rx.wait()).gasUsed;
  //console.log((await contract.connect(user)[method](...args, { gasLimit: 1000000 })).wait())
  //return (await contract.connect(user)[method](...args)).gasUsed;
  return gas;
}

async function main() {
  const [server, programmer, user1, user2, user3, user4] = await ethers.getSigners();

  const GasHolder = await ethers.getContractFactory("GasHolder");
  const gasHolder = await GasHolder.deploy(await server.getAddress(), await programmer.getAddress(), 18);
  await gasHolder.deployed();
  const RegUBI = await ethers.getContractFactory("RUSREG");
  const regUBI = await RegUBI.deploy(await programmer.getAddress(), gasHolder.address);
  const BirUBI = await ethers.getContractFactory("RUSBIR");
  const birUBI = await BirUBI.deploy(await programmer.getAddress(), gasHolder.address);
  await regUBI.deployed();
  await birUBI.deployed();

  await user1.sendTransaction({to: gasHolder.address, value: ethers.utils.parseEther("0.1")});
  await user2.sendTransaction({to: gasHolder.address, value: ethers.utils.parseEther("0.1")});
  await user3.sendTransaction({to: gasHolder.address, value: ethers.utils.parseEther("0.1")});
  await user4.sendTransaction({to: gasHolder.address, value: ethers.utils.parseEther("0.1")});

  const gas11 = await performTransaction(gasHolder, server, 'setAccounts', await user1.getAddress(), [regUBI.address], [1000], [1], [false], true);
  console.log(gas11.toString());
  const gas12 = await performTransaction(gasHolder, server, 'setAccounts', await user2.getAddress(), [regUBI.address], [1000], [1], [false], true);
  console.log(gas12.toString());
  console.log(`max gas for single account: ${Math.max(gas11, gas12)}`);

  const gas21 = await performTransaction(gasHolder, server, 'setAccounts', await user3.getAddress(), [regUBI.address, birUBI.address], [1000, 1001], [5, 6], [false, false], true);
  console.log(gas21.toString());
  const gas22 = await performTransaction(gasHolder, server, 'setAccounts', await user4.getAddress(), [regUBI.address, birUBI.address], [1000, 1001], [5, 6], [false, false], true);
  console.log(gas22.toString());
  console.log(`max gas for 2 accounts: ${Math.max(gas21, gas22)}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
