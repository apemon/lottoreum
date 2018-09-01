var express = require('express');
var bodyParser = require('body-parser');
var moment = require('moment');
var Web3 = require('web3');
var contract = require('truffle-contract');
var lottoContract = require('./../build/contracts/LottoPool.json');
var tokenContract = require('./../build/contracts/LottoToken.json');

var port = process.env.PORT || 4000;
var app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));
var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));

var lotto;
var token;
// setup contract
var Lotto = contract(lottoContract);
var Token = contract(tokenContract);
Lotto.setProvider(web3.currentProvider);
Token.setProvider(web3.currentProvider);
// initialize contract
Lotto.deployed().then(function (instance) {
    lotto = instance;
    Token.deployed().then(function (instance2) {
        token = instance2;
        app.listen(port, function () {
            console.log('Example app listening on port ' + port)
        });
    }, function(err) {
        console.log(err);
    });
}, function(err){
    console.log(err);
});

app.get('/hello', function(req,res) {
    res.send('hello');
});

app.get('/account/:addr', function(req, res) {
    var balance = web3.eth.getBalance(req.params.addr);
    res.send({
        eth: web3.fromWei(balance, 'ether').toNumber()
    });
});

app.get('/pool/create/:address/:value', function (req, res) {
    lotto.createPool("hello", req.params.value, {
        from: req.params.address,
        gas: 100000000
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/lotto/create/:address/:poolId/:lottoId/:price', function (req, res) {
    lotto.createLotto(req.params.poolId, req.params.lottoId, req.params.price, {
        from: req.params.address,
        gas: 2000000
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/lotto/:id', function (req, res) {
    lotto.ownerOf(req.params.id, {
        gas: 200000
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/pool/open/:address/:id', function (req, res) {
    lotto.openPool(req.params.id, {
        from: req.params.address,
        gas: 200000
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/pool/deposit/:from/:amount', function (req, res) {
    lotto.deposit(req.params.amount, {
        from: req.params.from,
        gas: 200000
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/lotto/buy/:address/:id/:value', function (req, res) {
    lotto.buyLotto(req.params.id, req.params.value, {
        from: req.params.address,
        gas: 2000000
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/pool/info/:id', function (req, res) {
    lotto.getPoolInfo(req.params.id, {
        
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/lotto/info/:id', function (req, res) {
    lotto.getLottoInfo(req.params.id, {
        
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/lotto/approve/:from/:to/:id', function (req, res) {
    lotto.approve(req.params.to, req.params.id, {
        from: req.params.from
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/token/buy/:from/:value', function (req, res) {
    token.buyLottoToken({
        from: req.params.from,
        value: web3.toWei(req.params.value, 'ether')
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/token/sell/:from/:value', function (req, res) {
    token.sellLottoToken(req.params.value, {
        from: req.params.from
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/token/balance/:address', function (req, res) {
    token.balanceOf( req.params.address ,{

    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/token/supply', function (req, res) {
    token.totalSupply({

    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/token/transfer/:from/:to/:amount', function (req, res) {
    token.transfer(req.params.to, req.params.amount, {
        from: req.params.from
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/token/approve/:from/:spender', function (req, res) {
    token.approve(req.params.spender, 1000000, {
        from: req.params.from
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/contract/:from/:address', function (req, res) {
    lotto.setTokenAddress(req.params.address, {
        from: req.params.from
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});