// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract CarteiraMoedaUnicaRede {
    mapping (address => uint) public balances;

    function deposito() external payable {
        balances[msg.sender] += msg.value;
    }

    function saque(uint256 valor) external {
        require(balances[msg.sender] >= valor, "Saldo insuficiente");
        balances[msg.sender] -= valor;
        payable(msg.sender).transfer(valor);
    }
}