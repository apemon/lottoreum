var Token = artifacts.require("./LottoToken.sol");

contract('LottoToken', function (accounts) {
    // basic functionality
    it("should buy correctly", function () {
        var token;
        var account1 = accounts[1];
        var balanceEth;
        var balance;
        
        return Token.deployed().then(function (instance) {
            token = instance;
            return token.balanceOf(account1);
        }).then(function(balanceA){
            balance = balanceA.toNumber();
            assert.equal(balance, 0, "initialize balance should be zero");
            return token.buyLottoToken({
                from: account1,
                value: web3.toWei(0.5, 'ether')
            })
        }).then(function() {
            return token.balanceOf.call(account1);
        }).then(function(balanceA){
            balance = balanceA.toNumber();
            assert.equal(balance, 5000, "buy token not work correctly");
        })
    });
});