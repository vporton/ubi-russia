const buidler = require("@nomiclabs/buidler");
const fs = require('fs');

const {deployIfDifferent, log} = deployments;

module.exports = async ({getNamedAccounts, deployments}) => {
    const namedAccounts = await getNamedAccounts();
    const {deploy} = deployments;
    const {deployer} = namedAccounts;
    const GasHolder = await deployments.get("GasHolder");
    log(`Deploying RUSREG...`);
    const deployResult = await deploy('RUSREG', {from: deployer, args: [env.OWNER_ADDRESS, GasHolder.address]});
    if (deployResult.newlyDeployed) {
        log(`contract RUSREG deployed at ${deployResult.address} in block ${deployResult.receipt.blockNumber} using ${deployResult.receipt.gasUsed} gas`);
    }
}
module.exports.tags = ['RUSREG'];
module.exports.dependencies = ['GasHolder'];
