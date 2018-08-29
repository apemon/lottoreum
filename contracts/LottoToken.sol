pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./Strings.sol";

contract LottoToken is Ownable, ERC721BasicToken {

    using SafeMath for uint;
    using strings for *;
    
    string public constant name = "Lottoreum";
    string public constant symbol = "LOL";

    struct Lotto {
        string number;
        uint poolId;
        uint price;
    }

    Lotto[] public lottos;
    
    event LottoCreated(uint poolId, string number, uint price);

    function _createLotto(uint _poolId, string _numString, uint _price) internal {
        uint i = 0;
        strings.slice memory temp = _numString.toSlice();
        strings.slice memory delimiter = ",".toSlice();
        uint length = temp.count(delimiter).add(1);
        while (i < length) {
            string memory _number = temp.split(delimiter).toString();
            Lotto memory lotto = Lotto(_number, _poolId, _price);
            uint id = lottos.push(lotto).sub(1);
            _mint(msg.sender, id);
            emit LottoCreated(_poolId, _number, _price);
            i = i.add(1);
        }
    }

    function getLottoInfo(uint _lottoId) public view returns (
        uint, string, uint, address
    ) {
        Lotto memory lotto = lottos[_lottoId];
        return (
            lotto.poolId,
            lotto.number,
            lotto.price,
            ownerOf(_lottoId)
        );
    }
}