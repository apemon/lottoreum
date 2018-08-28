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
    
    function totalPoolOwn(address _owner) public view returns (uint) {
        return ownerPoolCount[_owner];
    }

    function ownerOfPool(uint _id) public view returns (address) {
        return poolToOwner[_id];
    }

    function createPool(string _name) public payable {
        State state = State.Initial;
        Pool memory pool = Pool(_name, state, msg.value, msg.value);
        uint id = pools.push(pool).sub(1);
        poolToOwner[id] = msg.sender;
        ownerPoolCount[msg.sender].add(1);
        emit PoolCreated(id, _name, msg.value);
    }

    function createLotto(uint _poolId, string _numberString, uint price) public {
        require(poolToOwner[_poolId] == msg.sender, "must on the owner of the pool");
        Pool storage pool = pools[_poolId];
        if(pool.state != State.Initial)
            revert("invalid state");
        _createLotto(_poolId, _numberString, price);
    }

    function openPool(uint _poolId) public {
        require(poolToOwner[_poolId] == msg.sender, "must on the owner of the pool");
        Pool storage pool = pools[_poolId];
        if(pool.state != State.Initial)
            revert("invalid state");
        pool.state = State.Open;
    }

    function buyLotto(uint _lottoId) public payable {
        require(msg.value == lottos[_lottoId].price, "must buy at lotto price");
        Pool storage pool = pools[_poolId];
        if(pool.state != State.Open)
            revert("invalid state");
        Lotto memory lotto = lottos[_lottoId];
        uint _poolId = lotto.poolId;
        if(ownerOf(_lottoId) != poolToOwner[_poolId])
            revert("lotto must from the dealer");
        // transfer
        address poolOwner = poolToOwner[_poolId];
        safeTransferFrom(poolOwner, msg.sender, _lottoId);
        string memory number = lotto.number;
        pool.numberCount[number].add(1);
    }
}