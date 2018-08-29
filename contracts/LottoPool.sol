pragma solidity ^0.4.24;

import "./LottoToken.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract LottoPool is LottoToken {

    using SafeMath for uint;

    struct Pool {
        string name;
        State state;
        uint prize;
        uint balance;
        mapping (string => uint) numberCount;
    }

    Pool[] public pools;

    enum State {
        Initial,
        Open,
        Claim,
        Close
    }

    mapping (uint => address) poolToOwner;
    mapping (address => uint) ownerPoolCount;

    event PoolCreated(uint id, string name, uint balance);

    modifier onlyPoolOwner(uint _poolId) {
        require(poolToOwner[_poolId] == msg.sender, "must on the owner of the pool");
        _;
    }
    
    function totalPoolOwn(address _owner) public view returns (uint) {
        return ownerPoolCount[_owner];
    }

    function ownerOfPool(uint _id) public view returns (address) {
        return poolToOwner[_id];
    }

    function getPoolInfo(uint _poolId) public view returns (
        string, string, uint, uint
        ) {
        Pool memory pool = pools[_poolId];
        string memory state;
        if(State.Initial == pool.state)
            state = "Initial";
        else if(State.Open == pool.state)
            state = "Open";
        else if(State.Claim == pool.state)
            state = "Claim";
        else if(State.Close == pool.state)
            state = "Close";
        else state = "Unknown";
        return (
            pool.name,
            state,
            pool.prize,
            pool.balance);
    }

    function createPool(string _name) public payable {
        State state = State.Initial;
        Pool memory pool = Pool(_name, state, msg.value, msg.value);
        uint id = pools.push(pool).sub(1);
        poolToOwner[id] = msg.sender;
        ownerPoolCount[msg.sender].add(1);
        emit PoolCreated(id, _name, msg.value);
    }

    function createLotto(uint _poolId, string _numberString, uint price) public onlyPoolOwner(_poolId) {
        require(poolToOwner[_poolId] == msg.sender, "must on the owner of the pool");
        Pool storage pool = pools[_poolId];
        if(pool.state != State.Initial)
            revert("invalid state");
        _createLotto(_poolId, _numberString, price);
    }

    function openPool(uint _poolId) public onlyPoolOwner(_poolId) {
        require(poolToOwner[_poolId] == msg.sender, "must on the owner of the pool");
        Pool storage pool = pools[_poolId];
        if(pool.state != State.Initial)
            revert("invalid state");
        pool.state = State.Open;
    }

    function buyLotto(uint _lottoId) public payable {
        require(msg.value == lottos[_lottoId].price, "must buy at lotto price");
        Lotto memory lotto = lottos[_lottoId];
        uint _poolId = lotto.poolId;
        Pool storage pool = pools[_poolId];
        if(pool.state != State.Open)
            revert("invalid state");
        if(ownerOf(_lottoId) != poolToOwner[_poolId])
            revert("lotto must from the dealer");
        // transfer
        address poolOwner = poolToOwner[_poolId];
        safeTransferFrom(poolOwner, msg.sender, _lottoId);
        string memory number = lotto.number;
        pool.balance.add(msg.value);
        pool.numberCount[number].add(1);
    }
}