// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Carteira {
    IERC20 public immutable token;

    mapping (address => uint) public balances;

    constructor(address tokenAddress) {
          token = IERC20(tokenAddress);  
    }

    // a funcao payable envia fundos apenas da moeda nativa da rede
    function deposito(uint amount) external  {
        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }

    function saque(uint valor) external {
        require(balances[msg.sender] >= valor, "Saldo insuficiente");
        balances[msg.sender] -= valor;
        token.transfer(msg.sender, valor);
    }
}