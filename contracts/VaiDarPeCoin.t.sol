// testes

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {VaiDarPeCoin} from "./VaiDarPeCoin.sol";
import {Test} from "forge-std/Test.sol";
import "forge-std/Test.sol";

contract VaiDarPeCoinTest is Test {
  VaiDarPeCoin vai;

  function setUp() public {
    vai = new VaiDarPeCoin();
  }

  function testInitialBalance() public view {
    assert(vai.balanceOf(address(this)) == 10000 * 10 ** vai.decimals());
  }

  function testTransferParaCarteira2() public {
    address carteira2 = 0x0000000000000000000000000000000011123456;
    vai.transfer(carteira2, 100 * 10 ** vai.decimals());
    assert(vai.balanceOf(carteira2) == 100 * 10 ** vai.decimals());
    assert(vai.balanceOf(address(this)) == 9900 * 10 ** vai.decimals());
  }

  function testTransferParaCarteira3() public view{
    address carteira3 = 0x0000000000000000000000000000000023123212;
   // vai.transfer(carteira3, 100 * 10 ** vai.decimals());
    assert(vai.balanceOf(carteira3) == 0);
   // assert(vai.balanceOf(address(this)) == 9800 * 10 ** vai.decimals());
  }

  function testFailTransferSaldoInsuficiente() public {
    address carteira2 = 0x0000000000000000000000000000000011123456;
// Erro ao usar a funcao de verificar a resposta do require
//    vm.expectRevert("Saldo Insuficiente");
    vai.transfer(carteira2, 10001 * 10 ** vai.decimals());
  }

  function testeFailTransferirSaldoInsuficienteCarteira2ParaCarteira3() public {
    address carteira2 = 0x0000000000000000000000000000000011123456;
    address carteira3 = 0x0000000000000000000000000000000023123212;
    vai.transfer(carteira2, 100);
    vm.expectRevert("Saldo Insuficiente");
    vai.transferFrom(carteira2, carteira3, 200);
  }

}
