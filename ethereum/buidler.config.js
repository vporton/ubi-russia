usePlugin("@nomiclabs/buidler-waffle");
usePlugin('buidler-deploy');

// This is a sample Buidler task. To learn how to create your own go to
// https://buidler.dev/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(await account.getAddress());
  }
});

// You have to export an object to set up your config
// This object can have the following optional entries:
// defaultNetwork, networks, solc, and paths.
// Go to https://buidler.dev/config/ to learn more
module.exports = {
  // This is a sample solc configuration that specifies which version of solc to use
  solc: {
    version: "0.7.1",
    optimizer: {
      enabled: true,
      runs: 200
    },
  },
  networks: {
    buidlerevm: {
      // too many accounts
      accounts: [
        {
          privateKey: '0x0e206566a53a138f9500dd3ffaf12bbf3c773a34a0e78e6710b0726b82951e6d', // 0xfd95BF6727416050008dB2551c94C86D21bA3b77
          balance: '0xf0000000000000000',
        },
        {
          privateKey: '0x3d258b188e1e2bd69821990cc143830ce2be03dc24774c787090de8ef6bca214', // 0x4948C09461d37946Ea13b98d2C3f2D3C185fde2f
          balance: '0xf0000000000000000',
        },
        {
          privateKey: '0xdfe891177936f97142e0b8c6eefb7042d051536984a2bf2c46def1f01d37bf87', // 0x5530B1eC2bCD7B2fbDF780Ab5e7A4dE40541F3A8
          balance: '0xf0000000000000000',
        },
        {
          privateKey: '0xc37ae67042d02207a663c52522dc805089c3effb4aaf8e70195782e18b7c919a', // 0x2E8a38DA64876002DFF88B0f2855f7eE6A2B0aaD
          balance: '0xf0000000000000000',
        },
        {
          privateKey: '0xabcf6549a244d5314780a2e8943ce40cbcb172add81263a75672b64edc62d442', // 0x86169a588E2dd02cEae0366cCf5e3bfac59B6b55
          balance: '0xf0000000000000000',
        },
        {
          privateKey: '0xfd4e11610e26d3c3b114d42e27fe5bd378dc23046b704c650bb9f4caca7f5221', // 0x2a76D286FF3863a9e875E21A616bC68aaC49fe0E
          balance: '0xf0000000000000000',
        },
        {
          privateKey: '0x6f42c2787490726a233a7a1fe8ef3c77a3621e6aa3974004ea4cf1793d4149de', // 0xE31C81FF6cf5Dce8a5bBf3E75cB8E740FF406daf
          balance: '0xf0000000000000000',
        },
        {
          privateKey: '0x9f94c072e76e072dd7fcf5e11b5d816cfabd25a22c4dcfcedce867d89266928a', // 0x4FE7aED154b461586BBeDA5EDc37E39D93b4c4F2
          balance: '0xf0000000000000000',
        },
      ],
    },
    ganache: {
      gasLimit: 6000000000,
      defaultBalanceEther: 10,
      url: "http://localhost:8545",
      accounts: [
        '0xeb08ae8cd3d4d8c518fe7a1304fc937a59f9e1c2c7b25b79553ee75e4dd426d0',
        '0xdd9e428106a2905f550f76913e1b0c8b090e80d4dba8bfed80007d4c167d80a1',
        '0x97f9d4c14d18ad77fa2c56f52798482589e16cd1786511055b7fc41b55f95a7a',
        '0xce2bfda782e4c964108b99ce3327a859da2284555588ce336466f70909141245',
        '0xbaacf4a7bc2ba71fdd02e0d9f309a83fae97023e6fb5fbba2967a3f462e4560b',
        '0x347fa1a0aa101c156c9accbea6f85d0e48bc09d0cd4e70e3f12dd897d010fe62',
        '0x3159392037adfd20305fba956b9094feddb665cbab0d95bdb05bc72a7bfbe3a6',
        '0x9ba0ecc2d2589980fe568f1a3d8e1651466e9afaf4291cd9da07dbbefb3d37e7',
        '0x33496973dcb2de66cdf5e56013b49e6e3d7dfdc87c07d926c849715e01e67f14',
        '0xcd8ee4be282f2d2bb40879a9046eded85fdf301d69db3499859b4019ff0a34bc',
      ],
    },
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/1d0c278301fc40f3a8f40f25ae3bd328",
      accounts: process.env.RINKEBY_PRIVATE_KEY ? [process.env.RINKEBY_PRIVATE_KEY] : [],
    },
    mainnet: {
      url: "https://mainnet.infura.io/v3/1d0c278301fc40f3a8f40f25ae3bd328",
      accounts: process.env.MAINNET_PRIVATE_KEY ? [process.env.MAINNET_PRIVATE_KEY] : [],
    },
  },
  namedAccounts: {
    deployer: {
        default: 0, // here this will by default take the first account as deployer
        //4: '0xffffeffffff', // but for rinkeby it will be a specific address
    },
  },
};
