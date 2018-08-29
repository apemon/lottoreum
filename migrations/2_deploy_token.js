//var SafeMath = artifacts.require("./SafeMath.sol")
var LottoToken = artifacts.require("./LottoToken.sol");

module.exports = function(deployer) {
  //deployer.deploy(SafeMath);
  //deployer.link(SafeMath, Token);
  deployer.deploy(LottoToken, "Lottoreum", "LOL", 0);
};
