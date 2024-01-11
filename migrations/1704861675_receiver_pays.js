const ReceiverPays = artifacts.require("ReceiverPays");

module.exports = function(_deployer) {
  _deployer.deploy(ReceiverPays);
};
