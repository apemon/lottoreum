var express = require('express');
var bodyParser = require('body-parser');
var moment = require('moment');
var Web3 = require('web3');
var contract = require('truffle-contract');
var lottoContract = require('./../build/contracts/LottoPool.json');

var port = process.env.PORT || 4000;
var app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));
var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));

var lotto;
// setup contract
var Lotto = contract(lottoContract);
Lotto.setProvider(web3.currentProvider);
// initialize contract
Lotto.deployed().then(function (instance) {
    lotto = instance;
    app.listen(port, function () {
        console.log('Example app listening on port ' + port)
    });
}, function(err){
    console.log(err);
});

app.get('/hello', function(req,res) {
    res.send('hello');
});

app.get('/pool/create/:address/:value', function (req, res) {
    lotto.createPool("hello", {
        from: req.params.address,
        value: web3.toWei(req.params.value , 'ether'),
        gas: 100000000
    }).then(function(result){
        console.log(result);
        res.send(result);
    }, function(err){
        console.log(err);
        res.send(err);
    });
});

app.get('/lotto/create/:address/:poolId/:number/:price', function (req, res) {
    lotto.createLotto(req.params.poolId, req.params.number, web3.toWei(req.params.price, 'ether'), {
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

app.get('/lotto/buy/:address/:id', function (req, res) {
    lotto.buyLotto(req.params.id, {
        from: req.params.address,
        value: web3.toWei(2 , 'ether'),
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