//var SafeMath = artifacts.require("./SafeMath.sol")
var Lotto = artifacts.require("./LottoPool.sol");

module.exports = function(deployer) {
  //deployer.deploy(SafeMath);
  //deployer.link(SafeMath, Token);
  deployer.deploy(Lotto);
};
