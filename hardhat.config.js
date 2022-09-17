/** @type import('hardhat/config').HardhatUserConfig */

require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
   solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200}
      }
    },
   defaultNetwork: "rinkeby",
   networks: {
      hardhat: {},
      rinkeby: {
         //Insert the endpoint url below to connect to rinkeby
         url: "",
         accounts: [`0x${process.env.PRIVATE_KEY}`]
      }
   },
   etherscan:{
    apiKey: "Insert your etherscan api here"
   }
}