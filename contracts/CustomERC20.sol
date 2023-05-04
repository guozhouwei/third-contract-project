//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomERC20 is Ownable {
    using SafeMath for uint256;

    string public name;
    uint8 public decimals;
    string public symbol;
    uint256 public totalSupply;

    uint256 public tradeBurnRatio;
    uint256 public tradeFeeRatio;
    address public team;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) internal allowed;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Mint(address indexed user, uint256 value);
    event Burn(address indexed user, uint256 value);

    event ChangeTeam(address oldTeam, address newTeam);

    constructor(
        address _creator,   //代币合约创建者
        uint256 _initSupply,
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _tradeBurnRotio,
        uint256 _tradeFeeRatio,
        address _team
    ) {
        name = _name;
        symbol = _symbol;
        decimals = decimals;
        totalSupply = _initSupply;
        balances[_creator] = _initSupply;
        require(_tradeBurnRotio >= 0 && _tradeBurnRotio <= 5000, "TRADE_BURN_RATIO_INVALID");
        require(_tradeFeeRatio >= 0 && _tradeFeeRatio <= 5000, "TRADE_FEE_RATIO_INVALID");
        tradeBurnRatio = _tradeBurnRotio;
        tradeFeeRatio = _tradeFeeRatio;
        team = _team;
        emit Transfer(address(0), _creator, _initSupply);
    }

    //function transfer(address to, uint256 amount) public returns (bool) {
    //    _transfer(msg.sender, to, amount);
    //    return true;
    //}

    function balanceOf(address owner) public view returns (uint256 balance) {
        return balances[owner];
    }

   // function transferFrom(
   //     address from,
   //     address to
   // ) 

}