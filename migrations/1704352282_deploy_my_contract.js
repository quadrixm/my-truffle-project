const MyContract = artifacts.require("MyContract");

module.exports = function (_deployer) {
  _deployer.deploy(MyContract);
};
