pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./Strings.sol";

contract LottoAsset is Ownable, ERC721BasicToken {

    using SafeMath for uint;
    using strings for *;
    
    string public constant name = "Lottoreum";
    string public constant symbol = "LOL";

    struct Lotto {
        string number;
        uint poolId;
        uint price;
        uint prize;
    }

    Lotto[] public lottos;
    
    event LottoCreated(uint lottoId, uint poolId, string number, uint price);
    event LottoJackpot(uint lottoId, string number, uint prize);

    function _createLotto(uint _poolId, string _number, uint _price) internal returns(uint) {
        Lotto memory lotto = Lotto(_number, _poolId, _price, 0);
        uint id = lottos.push(lotto).sub(1);
        emit LottoCreated(id, _poolId, _number, _price);
        return (id);
    }

    function _transferLotto(address _to, uint _lottoId) internal {
        _mint(_to, _lottoId);
    }

    function getLottoInfo(uint _lottoId) public view returns (
        uint, string, uint, uint
    ) {
        Lotto memory lotto = lottos[_lottoId];
        return (
            lotto.poolId,
            lotto.number,
            lotto.price,
            lotto.prize
        );
    }
}