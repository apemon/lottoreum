pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract LottoToken is Ownable {

    struct Lotto {
        string number;
        uint poolId;
    }

    Lotto[] public lottos;
    
    mapping (uint => address) lottoToOwner;
    mapping (address => uint) ownerLottoCount;

    event LottoCreated(string number, uint poolId);

    function balanceOf(address _owner) public view returns (uint) {
        return ownerLottoCount[_owner];
    }

    function ownerOf(uint _id) public view returns (address) {
        return lottoToOwner[_id];
    }

    function _createLotto(uint _poolId, string _number) internal {
        Lotto memory lotto = Lotto(_number, _poolId);
        uint id = lottos.push(lotto) - 1;
        lottoToOwner[id] = msg.sender;
        ownerLottoCount[msg.sender]++;
        emit LottoCreated(_number, _poolId);
    }
}