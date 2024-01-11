const Ballot = artifacts.require("Ballot");

module.exports = function(_deployer) {
  _deployer.deploy(Ballot);
};
