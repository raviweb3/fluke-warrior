const { network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../helper-functions")
require("dotenv").config()

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let ethUsdPriceFeedAddress
    if (chainId == 31337) {
       //const ethUsdAggregator = await deployments.get("MockV3Aggregator")
       // ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
       // ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    log("----------------------------------------------------")
    log("Deploying FWStakeParts and waiting for confirmations...")
    const fwStakeParts = await deploy("FWStakeParts", {
        from: deployer,
        args: [],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`FWStakeParts deployed at ${fwStakeParts.address}`)

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(fwStakeParts.address, [])
    }
}

module.exports.tags = ["all", "fwStakeParts"]