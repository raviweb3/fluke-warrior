require("dotenv").config()
const { network } = require("hardhat")
const { networkConfig, 
        developmentChains,
        VERIFICATION_BLOCK_CONFIRMATIONS } = require("../helper-hardhat-config")
const { verify } = require("../helper-functions")

const FUND_AMOUNT = ethers.utils.parseEther("1") // 1 Ether, or 1e18 (10^18) Wei

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    const BASE_FEE = "250000000000000000" // 0.25 is this the premium in LINK?
    const GAS_PRICE_LINK = 1e9 // link per gas, is this the gas lane? // 0.000000001 LINK per gas

    let fwRewards
    let fwWarriorCollection
    let fwStockController
    let fwStakeParts
    let vrfCoordinatorV2Mock
   

    if (chainId == 31337) {
        fwRewards = await deployments.get("FWRewards")
        fwWarriorCollection = await deployments.get("FWWarriorCollection")
        fwStockController = await deployments.get("FWStockController")
        fwStakeParts = await deployments.get("FWStakeParts")
        vrfCoordinator = await deployments.get("VRFCoordinatorV2Mock")
        

        // create VRFV2 Subscription
        vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock")
        vrfCoordinatorV2Address = vrfCoordinatorV2Mock.address
        const transactionResponse = await vrfCoordinatorV2Mock.createSubscription()
        const transactionReceipt = await transactionResponse.wait()
        subscriptionId = transactionReceipt.events[0].args.subId
        // Fund the subscription
        // Our mock makes it so we don't actually have to worry about sending fund
        await vrfCoordinatorV2Mock.fundSubscription(subscriptionId, FUND_AMOUNT)
       // ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
       // ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }

    console.log(vrfCoordinatorV2Mock.address)    
    console.log(fwStockController.address)    
    console.log(fwStakeParts.address)    
    console.log(fwWarriorCollection.address)    
    console.log(fwRewards.address)    
   
    console.log(networkConfig[chainId]["gasLane"])   
    console.log(subscriptionId)   
    console.log(networkConfig[chainId]["callbackGasLimit"])   

    log("----------------------------------------------------")
    log("Deploying FWStorage and waiting for confirmations...")
    const fwStorage = await deploy("FWStorage", {
        from: deployer,
        args: [vrfCoordinatorV2Mock.address,
               fwStockController.address,
               fwStakeParts.address,
               fwWarriorCollection.address,
               fwRewards.address,
               networkConfig[chainId]["gasLane"],
               subscriptionId,
               networkConfig[chainId]["callbackGasLimit"]
        ],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`FWStorage deployed at ${fwStorage.address}`)

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(fwStorage.address, [])
    }
}

module.exports.tags = ["all", "fwStorage"]