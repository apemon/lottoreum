pragma solidity ^0.4.24;

import "./LottoToken.sol";

contract LottoPool is LottoToken {

    struct Pool {
        string name;
        string status;
        uint balance;
        mapping (string => uint) numberCount;
    }

    Pool[] public pools;

    mapping (uint => address) poolToOwner;
    mapping (address => uint) ownerPoolCount;

    event PoolCreated(uint id, string name, uint balance);
    
    function totalPoolOwn(address _owner) public view returns (uint) {
        return ownerLottoCount[_owner];
    }

    function ownerOfPool(uint _id) public view returns (address) {
        return lottoToOwner[_id];
    }

    function createPool(string _name) public payable {
        Pool memory pool = Pool(_name,"NEW",msg.value);
        uint id = pools.push(pool) - 1;
        poolToOwner[id] = msg.sender;
        ownerPoolCount[msg.sender]++;
        emit PoolCreated(id, _name, msg.value);
    }

    function createLotto(uint _poolId, string _number) public {
        require(poolToOwner[_poolId] == msg.sender);
        _createLotto(_poolId, _number);
        Pool storage pool = pools[_poolId];
        pool.numberCount[_number]++;
    }
}