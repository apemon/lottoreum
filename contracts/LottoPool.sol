pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./LottoAsset.sol";
import "./LottoToken.sol";
import "./Strings.sol";

contract LottoPool is Ownable, LottoAsset {

    using SafeMath for uint;
    using strings for *;

    ERC20 tokenContract;

    struct Pool {
        string name;
        bool isActive;
        uint balance;
        uint prize;
        uint totalLotto;
        mapping (string => uint[]) numberToLottos;
    }

    Pool[] public pools;
    
    uint[] activePool;
    uint public minPrize = 1000;
    uint public feeBalance;

    mapping (uint => address) poolToOwner;
    mapping (address => uint) ownerPoolCount;

    event PoolCreated(uint id, string name, uint balance);
    event PoolActive(uint poolId, uint totalLotto, uint prize);

    modifier onlyPoolOwner(uint _poolId) {
        require(poolToOwner[_poolId] == msg.sender, "must be the owner of the pool");
        _;
    }
    
    function () public payable {
        revert("we don't accept ETH");
    }

    function setTokenAddress(address _address) external onlyOwner {
        tokenContract = ERC20(_address);
    }

    function setMinPrize(uint _prize) public onlyOwner {
        minPrize = _prize;
    }

    function totalPoolOwn(address _owner) public view returns (uint) {
        return ownerPoolCount[_owner];
    }

    function ownerOfPool(uint _id) public view returns (address) {
        return poolToOwner[_id];
    }

    function createPool(string _name, uint _initialBalance) public {
        require(_initialBalance >= minPrize, "too low prize");
        require(tokenContract.balanceOf(msg.sender) >= _initialBalance, "not enough token");
        Pool memory pool = Pool(_name, false, _initialBalance, _initialBalance, 0);
        uint id = pools.push(pool).sub(1);
        poolToOwner[id] = msg.sender;
        ownerPoolCount[msg.sender].add(1);
        tokenContract.transferFrom(msg.sender, address(this), _initialBalance);
        emit PoolCreated(id, _name, _initialBalance);
    }

    function createLotto(uint _poolId, string _numString, uint _price) public onlyPoolOwner(_poolId) {
        Pool storage pool = pools[_poolId];
        require(pool.isActive == false, "pool already active");
        // begin batch create lotto
        uint i = 0;
        strings.slice memory temp = _numString.toSlice();
        strings.slice memory delimiter = ",".toSlice();
        uint length = temp.count(delimiter).add(1);
        while (i < length) {
            string memory _number = temp.split(delimiter).toString();
            _createLotto(_poolId, _number, _price);
            pool.totalLotto = pool.totalLotto.add(1);
            i = i.add(1);
        }
    }

    function openPool(uint _poolId) public onlyPoolOwner(_poolId) {
        Pool storage pool = pools[_poolId];
        require(pool.isActive == false, "pool already active");
        pool.isActive = true;
        activePool.push(_poolId);
        emit PoolActive(_poolId, pool.totalLotto, pool.prize);
    }

    function buyLotto(uint _lottoId, uint _value) public {
        require(_value <= tokenContract.balanceOf(msg.sender), "not enough token");
        Lotto memory lotto = lottos[_lottoId];
        require(_value == lotto.price, "must buy at lotto price");
        uint _poolId = lotto.poolId;
        Pool storage pool = pools[_poolId];
        require(pool.isActive == true, "pool must active");
        // transfer
        tokenContract.transferFrom(msg.sender, address(this), _value);
        _transferLotto(msg.sender, _lottoId);
        pool.numberToLottos[lotto.number].push(_lottoId);
        pool.balance.add(_value);
    }

    function luckyDraw(string _number) public {
        
    }
}