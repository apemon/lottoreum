var LottoToken = artifacts.require("./LottoToken.sol");

contract('LottoToken', function (accounts) {
    // basic functionality
    it("should has correct property", function () {

        var token;
        var name;
        var symbol;

        return LottoToken.deployed().then(function (instance) {
            token = instance;
            console.log(token);
            return instance.name.call();
        }).then(function (_name) {
            name = _name;
            return token.symbol.call();
        }).then(function (_decimals) {
            assert.equal(name, "LottoToken");
            assert.equal(symbol, "LOL", "Token Symbol is incorrect");
        });
    });
});