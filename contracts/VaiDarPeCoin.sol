
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract VaiDarPeCoin {

    event Transfer(address indexed from, address indexed to, uint256 value);
    
    string private constant _name="VaiDarPeCoin";
    string private constant _symbol="VAI";
    uint8 private constant _decimals=18;
    uint256 private constant _totalSupply = 10000 * 10 ** _decimals;

    mapping (address => uint256) private _balances;

    constructor() {
        _balances[msg.sender] = _totalSupply;
    }

    function name() public pure returns (string memory) {
        return _name;
    }
    function symbol() public pure returns (string memory) {
        return _symbol;
    }
    function decimals() public pure returns (uint) {
        return _decimals;
    }
    function totalSupply() public pure returns (uint) {
        return _totalSupply;
    }        

    function balanceOf(address owner) public view returns(uint256) {
        return _balances[owner];
    }

    function transfer(address to, uint256 value) public returns(bool) {
        require(balanceOf(msg.sender) >= value, "Saldo Insuficiente");
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    mapping( address => mapping( address => uint256 ) ) private _allowances;

    function allowances(address _owner, address _spender) public view returns (uint256) {
        return _allowances[_owner][_spender];
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function approve(address spender, uint256 value) public returns (bool) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    } 

    function transferFrom(address from, address to, uint256 value) public returns(bool) {
        require(balanceOf(from) >= value, "Saldo Insuficiente");
        require(allowances(from, msg.sender) >= value, "Insufficient allowance");
        _allowances[from][msg.sender] -= value;
        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
        return true; 
    }

}