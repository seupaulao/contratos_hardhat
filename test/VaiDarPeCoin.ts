import * as chai from "chai";

import { createPublicClient, createWalletClient, formatEther, http } from "viem";
import { describe, it } from "node:test";

import assert from "node:assert/strict";
import chaiAsPromised from "chai-as-promised";
import { expect } from "chai";
import { network } from "hardhat";

chai.use(chaiAsPromised);

describe ("Teste no contrato ERC-20 VaiDarPeCoin", async function(){
  const {viem} = await network.connect();
  const publicClient = await viem.getPublicClient();

  it("get saldo de 2 carteiras da rede publica", async function () {
    //const vai = await viem.deployContract("VaiDarPeCoin");
    const qty = 10000000000000000000000n;
    //assert.equal(qty, await vai.read.totalSupply());
    const [carteira1, carteira2] = await viem.getWalletClients();
    const carteira1Balance = await publicClient.getBalance({address: carteira1.account.address});
    //const carteira2Balance = await publicClient.getBalance({address: carteira2.account.address});
    //console.log(`Saldo de ${carteira1.account.address} : ${formatEther(carteira1Balance)} ETH`);
   //console.log(`Saldo de ${carteira2.account.address} : ${formatEther(carteira2Balance)} ETH`);
    assert.equal(formatEther(qty), formatEther(carteira1Balance));

   // assert.equal(qty, await vai.read.balanceOf(carteira1.getAddresses()));
    
  });
  
  it("owner (carteira 1) transfere 100 para carteira 2", async function () {
    const [carteira1, carteira2] = await viem.getWalletClients();
    const vai = await viem.deployContract("VaiDarPeCoin");
    //const qty = 10000000000000000000000n;
    const tot = await vai.read.totalSupply();
    //console.log(`Saldo C1: ${await vai.read.balanceOf([carteira1.account.address])} `);
    //console.log(`Saldo C2: ${await vai.read.balanceOf([carteira2.account.address])} `);
    await vai.write.transfer([carteira2.account.address, 100n]);
    console.log(`Saldo total inicial: ${formatEther(tot)} ETHERS = ${tot} WEI`);
    console.log(`Saldo C1: ${await vai.read.balanceOf([carteira1.account.address])} `);
    console.log(`Saldo C2: ${await vai.read.balanceOf([carteira2.account.address])} `);
  });
  
  it("consultar o saldo do owner e ver que diminuiu 100", async function () {
    const [carteira1, carteira2] = await viem.getWalletClients();
    const vai = await viem.deployContract("VaiDarPeCoin");
    await vai.write.transfer([carteira2.account.address, 100n]);
    const operacao = (await vai.read.totalSupply()) - (await vai.read.balanceOf([carteira1.account.address]));
    assert.equal(100n, operacao);
  });

  it("consultar o saldo da carteira 2 e ver que aumentou 100", async function () {
    const [carteira1, carteira2] = await viem.getWalletClients();
    const vai = await viem.deployContract("VaiDarPeCoin");
    await vai.write.transfer([carteira2.account.address, 100n]);
    const operacao = (await vai.read.balanceOf([carteira2.account.address]));
    assert.equal(100n, operacao);
  });

  it("consultar o saldo da carteira 3 e ver 0", async function () {
    const [carteira1, carteira2, carteira3] = await viem.getWalletClients();
    const vai = await viem.deployContract("VaiDarPeCoin");
    await vai.write.transfer([carteira2.account.address, 100n]);
    const operacao = (await vai.read.balanceOf([carteira3.account.address]));
    assert.equal(0n, operacao);
  });

  it("carteira 2 tentar transferir 200 para carteira 3 (deve dar erro)", async function () {
    const [carteira1, carteira2, carteira3] = await viem.getWalletClients();
    const vai = await viem.deployContract("VaiDarPeCoin");
    await vai.write.transfer([carteira2.account.address, 100n]);
    await expect(vai.write.transferFrom([carteira2.account.address, carteira3.account.address, 200n])).to.be.rejectedWith("Saldo Insuficiente");    
  });

  it("carteira 2 autoriza carteira 3 de fazer transferências em seu nome no valor de 50", async function () {
    const [carteira1, carteira2, carteira3] = await viem.getWalletClients();
    const vai = await viem.deployContract("VaiDarPeCoin");
    await expect(vai.write.approve([carteira3.account.address, 50n])).to.be.fulfilled;
  });

  it("consultar allowance na carteira 2 para carteira 3 (deve retornar 50)", async function () {
    const [carteira2, carteira3] = await viem.getWalletClients();
    const vai = await viem.deployContract("VaiDarPeCoin");
   // await vai.write.transfer([carteira2.account.address, 100n]);
    await vai.write.approve([carteira3.account.address, 50n]);
    const p1 = await vai.read.allowances([carteira2.account.address, carteira3.account.address]);
    const p2 = await vai.read.allowances([carteira3.account.address, carteira2.account.address]);
    
    //console.log(`Allowance de C2 para C3: ${p1}`);
   // console.log(`Allowance de C3 para C2: ${p2}`);

    const operacao = (await vai.read.allowances([carteira2.account.address, carteira3.account.address]));
    assert.equal(50n, operacao);
  });

  it("consultar allowance na carteira 2 para carteira 1 (deve retornar 0)", async function () {
    const [carteira1, carteira2, carteira3] = await viem.getWalletClients();
    const vai = await viem.deployContract("VaiDarPeCoin");
    const operacao = (await vai.read.allowances([carteira2.account.address, carteira1.account.address]));
    assert.equal(0n, operacao);
  });

  it("owner (1) tentar transferir da carteira 2 para a 3 (deve falhar, ele não tem permissão na carteira 2)", async function () {
    const [carteira1, carteira2, carteira3] = await viem.getWalletClients();
    const vai = await viem.deployContract("VaiDarPeCoin",[], {client: {wallet: carteira1}});

    await vai.write.approve([carteira3.account.address, 50n]);
    const p1 = await vai.read.allowances([carteira1.account.address, carteira2.account.address]);
    const p2 = await vai.read.allowances([carteira1.account.address, carteira3.account.address]);
    const p3 = await vai.read.allowances([carteira2.account.address, carteira3.account.address]);
    console.log(`Allowance de C1 para C2: ${p1}`);
    console.log(`Allowance de C1 para C3: ${p2}`);
    console.log(`Allowance de C2 para C3: ${p3}`);
    await expect(vai.write.transferFrom([carteira2.account.address, carteira3.account.address, 20n])).to.be.rejectedWith("Saldo Insuficiente");
  });

  it("carteira 3 transfere 30 da carteira 2 para owner (1)", async function () {
    
  });
  
  it("consultar saldos de 1 (deve ter +30) e 2 (deve ter -30)", async function () {
    
  });
  
  it("consultar allowance na carteira 2 para a 3 (deve ter 20 restante)", async function () {
    
  });
  
  it("carteira 3 tentar transferir 100 da carteira 2 para owner (deve falhar, o allowance restante é apenas 20)", async function () {
    
  });  
  
});

