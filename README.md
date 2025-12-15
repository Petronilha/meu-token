# 🪙 Token Swap Ecosystem & Custom ERC-20

Este repositório contém uma implementação completa e manual do padrão **ERC-20** e um sistema de **Atomic Swap** (Troca Atômica) para negociações peer-to-peer (P2P).

O objetivo deste projeto é demonstrar um entendimento profundo da arquitetura de contratos inteligentes, manipulação de estado, segurança e padrões de design em Solidity, sem depender cegamente de bibliotecas externas para a lógica central.

## 🚀 Funcionalidades

### 1. Implementação ERC-20 Customizada (`ERC20.sol`)
Diferente de apenas importar contratos prontos, este token foi construído do zero seguindo a interface `IERC20`.
- **Controle de Acesso:** Função `mint` restrita ao dono do contrato.
- **Segurança de Queima (Burn):** Implementação segura onde usuários só podem queimar seus próprios tokens (`msg.sender`), prevenindo riscos de centralização/confisco.
- **Eficiência de Gás:** Mapeamentos otimizados para `balanceOf` e `allowance`.

### 2. Sistema de Troca Atômica (`Swap.sol`)
Um contrato inteligente que atua como um "Escrow" descentralizado para garantir trocas justas entre duas partes.
- **Trustless:** A troca só ocorre se ambas as partes tiverem saldo e tiverem aprovado o contrato.
- **Atômico:** A transação é "tudo ou nada". Se uma transferência falhar, toda a operação é revertida.
- **Segurança:** Verificações estritas de `allowance` antes da execução para evitar falhas e perda de taxas de gás.

## 📂 Estrutura do Projeto

```text
contracts/
├── ERC20.sol       # Lógica base do token (State variables, mappings, events)
├── IERC20.sol      # Interface padrão (Interoperabilidade)
├── TokenA.sol      # Token de exemplo para testes (Herda de ERC20)
├── TokenB.sol      # Token de exemplo para testes (Herda de ERC20)
└── Swap.sol        # Contrato de negociação (Lógica de Atomic Swap)
````

## 🛠️ Tecnologias Utilizadas

  - **Solidity** ^0.8.27
  - **Hardhat** (Ambiente de desenvolvimento)
  - **Ethers.js** (Interação com Blockchain)
  - **TypeScript** (Tipagem estática para scripts)

## ⚙️ Como Funciona o Swap

O contrato `Swap.sol` resolve o problema de confiança em trocas P2P (OTC). O fluxo é o seguinte:

1.  **Definição do Acordo:** O contrato é implantado definindo quem troca o quê (`TokenA` por `TokenB`, quantidades e endereços dos donos).
2.  **Aprovação (Approve):**
      - O `Dono 1` aprova o contrato `Swap` a gastar seus tokens A.
      - O `Dono 2` aprova o contrato `Swap` a gastar seus tokens B.
3.  **Execução (Swap):**
      - Qualquer uma das partes chama a função `swap()`.
      - O contrato verifica as aprovações e saldos.
      - O contrato usa `transferFrom` para puxar os tokens de ambos e enviar para as contrapartes simultaneamente.

## 📦 Instalação e Compilação

Para clonar e verificar os contratos em sua máquina local:

```bash
# 1. Clone o repositório
git clone [https://github.com/Petronilha/meu-token.git](https://github.com/Petronilha/meu-token.git)

# 2. Instale as dependências
npm install

# 3. Compile os contratos inteligentes
npx hardhat compile
```

## 🛡️ Decisões de Design e Segurança

  - **Private Helpers:** Uso de funções com prefixo `_` (ex: `_safeTransferFrom`, `_mint`) para encapsular lógica crítica e evitar repetição de código.
  - **Checks-Effects-Interactions:** O design prioriza verificações (`require`) antes de realizar alterações de estado ou transferências externas.
  - **NatSpec:** O código utiliza comentários no padrão NatSpec para documentação automática e clareza.

## 👤 Autor

**Daniel Petronilha**

  - GitHub: [@Petronilha](https://www.google.com/search?q=https://github.com/Petronilha)

-----

*Este projeto é para fins educacionais e de portfólio.*
