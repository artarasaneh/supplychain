//const ConvertLib = artifacts.require("ConvertLib");
const Storage = artifacts.require("Storage");
const CementSupplyChain = artifacts.require("CementSupplyChain");
module.exports = function(deployer) {
    deployer.deploy(Storage);
    deployer.deploy(CementSupplyChain);
    //deployer.link(ConvertLib, MetaCoin);
    // deployer.deploy(MetaCoin);
};