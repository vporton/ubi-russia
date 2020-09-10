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
      accounts: [ // call `ganache-cli -d`
        '0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d',
        '0x6cbed15c793ce57650b9877cf6fa156fbef513c4e6134f022a85b1ffdd59b2a1',
        '0x6370fd033278c143179d81c5526140625662b8daa446c22ee2d73db3707e620c',
        '0x646f1ce2fdad0e6deeeb5c7e8e5543bdde65e86029e2fd9fc169899c440a7913',
        '0xadd53f9a7e588d003326d1cbf9e4a43c061aadd9bc938c843a79e7b4fd2ad743',
        '0x395df67f0c2d2d9fe1ad08d1bc8b6627011959b79c53d7dd6a3536a33ab8a4fd',
        '0xe485d098507f54e7733a205420dfddbe58db035fa577fc294ebd14db90767a52',
        '0xa453611d9419d0e56f499079478fd72c37b251a94bfde4d19872c44cf65386e3',
        '0x829e924fdf021ba3dbbc4225edfece9aca04b929d6e75613329ca6f1d31c0bb4',
        '0xb0057716d5917badaf911b193b12b910811c1497b5bada8d7711f758981c3773',
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
