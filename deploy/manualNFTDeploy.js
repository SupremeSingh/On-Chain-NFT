let { networkConfig } = require('../hardhat-helper-config')
const fs = require('fs')

module.exports = async ({
    getNamedAccounts,
    deployments,
    getChainId
}) => {

    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = await getChainId()

    const accounts = await hre.ethers.getSigners()
    const signer = accounts[0]

    log("----------------------------------------------------")

    const ManualNFTContract = await ethers.getContractFactory("manualNFT")
    const deployedNFTContract = await ManualNFTContract.deploy()
    await deployedNFTContract.deployed()

    const networkName = networkConfig[chainId]['name']

    log(`Verify with:\n npx hardhat verify --network ${networkName} ${deployedNFTContract.address}`)
    

    let filepath = "./media/pumpkin.svg"
    let svg = fs.readFileSync(filepath, { encoding: "utf8" })
    log(`We will use ${filepath} as our SVG, and this will turn into a tokenURI. `)

    tx = await deployedNFTContract.create(svg)
    await tx.wait(1)

    let tokenID_BN = await deployedNFTContract.addressToTokenID(deployer)
    let tokenID = tokenID_BN.toNumber()

    console.log(tokenID)

    log(`You can view the tokenURI here \n ${await deployedNFTContract.tokenURI(0)}`)

}
module.exports.tags = ['all', 'svg']