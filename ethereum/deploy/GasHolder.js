const buidler = require("@nomiclabs/buidler");
const fs = require('fs');

const {deployIfDifferent, log} = deployments;

module.exports = async ({getNamedAccounts, deployments}) => {
    const namedAccounts = await getNamedAccounts();
    const {deploy} = deployments;
    const {deployer} = namedAccounts;
    log(`Deploying GasHolder...`);
    const deployResult = await deploy(
        'GasHolder',
        {from: deployer,
         args: [process.env.SERVER_ADDRESS, process.env.PROGRAMMER_ADDRESS, 18]});
    if (deployResult.newlyDeployed) {
        log(`contract GasHolder deployed at ${deployResult.address} in block ${deployResult.receipt.blockNumber} using ${deployResult.receipt.gasUsed} gas`);
    }
}
module.exports.tags = ['GasHolder'];
