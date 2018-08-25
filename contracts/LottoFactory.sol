pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract LottoFactory is Ownable {

    string luckyNumber;
    uint price = 0.01 ether;

    mapping (string => address) lottoToOwner;
    mapping (address => uint) ownerLottoCount;

    event LottoPurchase(address _owner, string _number);

    function balanceOf(address _owner) public view returns (uint) {
        return ownerLottoCount[_owner];
    }

    function ownerOf(string number) public view returns (address) {
        return lottoToOwner[number];
    }

    function _createLotto(string _number) internal {
        lottoToOwner[_number] = msg.sender;
        ownerLottoCount[msg.sender]++;
        emit LottoPurchase(msg.sender, _number);
    }

    function createLotto(string _number) public payable {
        // need to check that no one has purchase this lotto
        require(lottoToOwner[_number] == address(0));
        require(msg.value == price);
        _createLotto(_number);
    }

    function setLuckyNumber(string _number) public onlyOwner {
        luckyNumber = _number;
        // transfer money to winner
        address _winner = lottoToOwner[luckyNumber];
        if(_winner != address(0)) {
            _winner.transfer(this.balance);
        }
    }

    function setLottoPrice(uint _price) public onlyOwner {
        price = _price;
    }
}