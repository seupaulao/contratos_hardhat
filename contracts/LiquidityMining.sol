// SPDX-License-Indetifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ILPToken.sol";

/**
 03. Existem situações em nossos contratos em que temos validações iguais acontecendo em 
 funções diferentes. 

 Por exemplo, um controle de acesso em algumas funções administrativas. 
 */
import "@openzeppelin/contracts/access/Ownable.sol";

//verificar se o contrato abstract é necessário
contract LiquidityMining is Ownable {
    IERC20 public token;
    ILPToken public recompensa;

    mapping(address => uint) public balances;
    mapping(address => uint) public checkpoints; 

    uint public rewardFactor = 100;
    uint public periodFactor = 30 * 24 * 60 * 60; //30 dias em segundos

    //Recompensas = Saldo * Tempo * Rentabilidade

    constructor (address tokenAddress, address rewardAddress) Ownable(msg.sender) {
        token = IERC20(tokenAddress);
        recompensa = ILPToken(rewardAddress);
    }

    function deposit(uint amount) external {
        require(amount > 0, "Quantidade invalida!");
        require(balances[msg.sender] == 0, "Saldo insuficiente ou Erro no deposito");
        token.transferFrom(msg.sender, address(this),amount);
        balances[msg.sender]=amount;
        checkpoints[msg.sender]=block.timestamp;
    }

    /**
     * 01. TESTES até deposit
     * 
     * 1. como conta 1, faça o deploy da MOEDA, tome nota do endereço deste contrato; 
     * 
     * 2. como conta 1, transfira 1 MOEDA inteira para a conta 2 e verifique o saldo de MOEDA dela; 
     * 
     * 3. como conta 1, faça o deploy da TokenLiquidez, tome nota do endereço deste contrato; 
     * 
     * 4. como conta 1, faça o deploy do LiquidityMining informando o endereço da MOEDA e 
     * da TokenLiquidez, tome nota do endereço deste novo contrato; 
     * 
     * 5. como conta 1, no contrato TokenLiquidez chame a função setLiquidityMining passando 
     * o endereço do contrato LiquidityMining;
     * 
     * 6. como conta 2, no contrato MOEDA chame a funcao approve informando 
     * o endereço do contrato LiquidityMining e a quantia de 1 ether inteiro;
     * 
     * 7. como conta 2, no contrato LiquidityMining chame a função deposit informando
     * a quantia de 1 ether inteiro;
     * 
     * 8. verifique o saldo de MOEDA na conta 2 e também do LiquidityMining para ver se
     * estão corretos (saiu 1 ether do primeiro e foi para o segundo);
     */

    // fator_tempo = ( instante_atual - instante_deposito ) / tamanho_bloco
    function _calculateRewards(uint balance) private view returns (uint) {
        uint timeFactor = (block.timestamp - checkpoints[msg.sender]) / periodFactor;
        if (timeFactor < 1) return 0;
        return balance * timeFactor * rewardFactor / 10000;
    }

    // chamada pra saber quanto receberia de recompensa caso sacasse tudo agora
    function calculateRewards() public view returns (uint) {
        return _calculateRewards(balances[msg.sender]);
    }

    // chamada por qualquer pessoa q acompanhar o total de saldo depositado do nosso protocolo
    function poolBalance() external view returns (uint) {
        return token.balanceOf(address(this));
    }

    function rewardPayment(uint balance, address to) private {
        uint rewardAmount = _calculateRewards(balance);
        recompensa.mint(to, rewardAmount);
        checkpoints[to] = block.timestamp + 1;
    }

    //saque
    function withdraw(uint amount) external {
        require(amount > 0, "Invalid amount");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        uint originalBalance = balances[msg.sender];
        balances[msg.sender] -= amount;
        rewardPayment(originalBalance, msg.sender);
        token.transfer(msg.sender, amount);
    } 

    /**
     * 02. Testes
     * obs : defina periodFactor para algo entre 30s e 60s
     * 
     * 1. espere algum tempo e consulte a calculateRewards para ver se já tem recompensa para a conta 2; 
     * 
     * 2. quando tiver recompensas, com a conta 2 faça um saque de metade do saldo total;
     * 
     * 3. saque de metade do saldo total;
     * 
     * 4. consulte o novo saldo da conta 2 no LiquidityMining, ele deve estar em metade do que tinha antes;
     * 
     * 5. consulte o novo saldo da conta 2 no LiquidityToken, ele deve estar com o total de recompensas recebido;
     * 
     * 6. consulte o total supply do LiquidityToken, ele deve estar no mesmo valor do que foi mintado recentemente;
     * 
     * 7. consulte o novo saldo da conta 2 no LuizCoin, ele deve estar com o valor que sacou a mais;
     * 
     * 8. aguarde mais algum tempo até ter novas recompensas e repita o processo zerando sua posição no pool
     */

    modifier isBloqueado() {
        require (token.balanceOf(address(this)) == 0, "Pool Blocked");
        _;
    }

    function setRewardFactor(uint newRewardFactor) external onlyOwner isBloqueado{
        rewardFactor = newRewardFactor;
    }

    function setPeriodFactor(uint newPeriodFactor) external onlyOwner isBloqueado{
        periodFactor = newPeriodFactor;
    }
 
}

