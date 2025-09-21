# Sample Hardhat 3 Beta Project (`node:test` and `viem`)

This project showcases a Hardhat 3 Beta project using the native Node.js test runner (`node:test`) and the `viem` library for Ethereum interactions.

To learn more about the Hardhat 3 Beta, please visit the [Getting Started guide](https://hardhat.org/docs/getting-started#getting-started-with-hardhat-3). To share your feedback, join our [Hardhat 3 Beta](https://hardhat.org/hardhat3-beta-telegram-group) Telegram group or [open an issue](https://github.com/NomicFoundation/hardhat/issues/new) in our GitHub issue tracker.

## Project Overview

This example project includes:

- A simple Hardhat configuration file.
- Foundry-compatible Solidity unit tests.
- TypeScript integration tests using [`node:test`](nodejs.org/api/test.html), the new Node.js native test runner, and [`viem`](https://viem.sh/).
- Examples demonstrating how to connect to different types of networks, including locally simulating OP mainnet.

## Usage

### Running Tests

To run all the tests in the project, execute the following command:

```shell
npx hardhat test
```

You can also selectively run the Solidity or `node:test` tests:

```shell
npx hardhat test solidity
npx hardhat test nodejs
```
### Opcao 1: Subindo o no local

```shell
npx hardhat node
```

### Opcao 2: Fork de uma rede existente

```shell
npx hardhat node --fork <url infura ou alchemy>
```

### Script para subir o blockchain local

```json
"scripts": {
  "start": "npx hardhat node"
},
```

Run tests specific contract:

```shell
 npx hardhat test solidity contracts/Counter.t.sol 
 ```

### Make a deployment to Sepolia

This project includes an example Ignition module to deploy the contract. You can deploy this module to a locally simulated chain or to Sepolia.

Usar faucet em 

https://sepolia-faucet.pk910.de/#/

https://learnweb3.io/faucets/sepolia/

https://cloud.google.com/application/web3/faucet/ethereum/sepolia

Validador de blocos em:

https://sepolia.etherscan.io/

To run the deployment to a local chain:

```shell
npx hardhat ignition deploy ignition/modules/Counter.ts
```

To run the deployment to Sepolia, you need an account with funds to send the transaction. The provided Hardhat configuration includes a Configuration Variable called `SEPOLIA_PRIVATE_KEY`, which you can use to set the private key of the account you want to use.

You can set the `SEPOLIA_PRIVATE_KEY` variable using the `hardhat-keystore` plugin or by setting it as an environment variable.

To set the `SEPOLIA_PRIVATE_KEY` config variable using `hardhat-keystore`:

```shell
npx hardhat keystore set SEPOLIA_PRIVATE_KEY
```

Para deploy também é necessário saber a URL do RPC da Sepolia,
então a variável SEPOLIA_RPC_URL deve ser configurada no
comando a seguir:

```shell
npx hardhat keystore set SEPOLIA_RPC_URL
```


Depois de configurar as variáveis é possível agora
fazer o deploy na rede sepolia:

```shell
npx hardhat ignition deploy --network sepolia ignition/modules/Counter.ts
```

Para verificar o contrato do contrato:

**Primeiro** é necessário configurar o valor 
de mais uma variável na keystore, a `ETHERSCAN_APIKEY`.
Seu valor deve estar em `etherscan.io` na conta que vc abriu.

```shell
npx hardhat keystore set ETHERSCAN_APIKEY
```

Note que todas essas variáveis definidas com `hardhat keystore`
estão no arquivo `hardhat.config.ts`.

**Segundo** Aplicar o comando `verify` no contrato deployed
na pasta ignition:

```shell
npx hardhat ignition verify --network sepolia NOME_DEPLOY_DA_PASTA_DEPLOYMENTS_IGNITION --show-stack-traces
```

Onde:
- show-stack-traces
  - ativa o modo de mostrar na tela caso haja erro

Se sucesso abre algo assim:

```bash
contracts/LivroDatabase.sol:LivroDatabase
  Explorer: https://sepolia.etherscan.io/address/ENDERECO_TRANSACAO#code
```

Deve pegar o **ENDERECO_TRANSACAO** e colocar no sepolia.etherscan.io

No **Read Contract** vai ter os métodos de leitura:
 - getLivro
 - a lista 'livros'

No **Write Contract** vai ter os métodos de gravação
- addLivro
- deleteLivro
- updateLivro

Observação: Sempre que for usar qualquer 
metodo acima é necessário estar conectado a web3

Logo, na sepolia.etherscan.io, 
clique no botão vermelho `connect to web3` aí ele 
vai se conectar a carteira vinculada ao browser



### Coisas a se fazer

OK 1. fazer o deploy para testenet usando o hardhat
   - preencher o arquivo `.env` corretamente com os dados necessarios 
     - NAO FUNCIONA, ao inves deve usar hardhat-keystore, porque estamos usando ignition e nao deploy.js

OK 2. testar/verificar o contrato na testenet
   - o verify so funciona se fizer de dentro do IDE, no caso, HARDHAT, se levar pra outro IDE o codigo vai der erro

OK 3. Fazer um DAPP que use esse contrato via ABI

OK 4. Fazer um DAPP que consulte saldo e envie fundo entre contas