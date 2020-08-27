const buidler = require("@nomiclabs/buidler");
const fs = require('fs');

const {deployIfDifferent, log} = deployments;

module.exports = async ({getNamedAccounts, deployments}) => {
    const namedAccounts = await getNamedAccounts();
    const {deploy} = deployments;
    const {deployer} = namedAccounts;
    const GasHolder = await deployments.get("GasHolder");
    log(`Deploying RUSBIR...`);
    const deployResult = await deploy('RUSBIR', {from: deployer, args: [env.OWNER_ADDRESS, GasHolder.address]});
    if (deployResult.newlyDeployed) {
        log(`contract RUSBIR deployed at ${deployResult.address} in block ${deployResult.receipt.blockNumber} using ${deployResult.receipt.gasUsed} gas`);
    }
}
module.exports.tags = ['RUSBIR'];
module.exports.dependencies = ['GasHolder'];
