pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract LottoToken is Ownable, StandardToken, DetailedERC20 {

    using SafeMath for uint;

    uint public rate = 100000000000000; // wei per token

    event Mint(address indexed to, uint amount, uint rate);
    event Burn(address indexed burner, uint amount, uint rate);

    constructor (string _name, string _symbol, uint8 _decimal) 
        DetailedERC20(_name, _symbol, _decimal) public {
        
    }

    function setRate(uint _rate) public onlyOwner {
        rate = _rate;
    }

    function buyLottoToken() public payable {
        require(msg.value >= rate, "not enough money");
        uint weiAmount = msg.value;
        uint tokens = weiAmount.div(rate);
        uint change = weiAmount % rate;
        msg.sender.transfer(change);
        _mint(msg.sender, tokens);
    }

    function sellLottoToken(uint _amount) public {
        require(_amount <= balances[msg.sender], "not enough token");
        uint weiAmount = _amount.mul(rate);
        msg.sender.transfer(weiAmount);
        _burn(msg.sender, _amount);
    }

    function _mint(address _to, uint _amount) internal {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount, rate);
        emit Transfer(address(0), _to, _amount);
    }

    function _burn(address _to, uint _amount) internal {
        balances[_to] = balances[_to].sub(_amount);
        totalSupply_ = totalSupply_.sub(_amount);
        emit Burn(_to, _amount, rate);
        emit Transfer(_to, address(0), _amount);
    }
}