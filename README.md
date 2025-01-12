# Account Abstraction (Ethereum)

With this Foundry project you can create a simple Account Abstraction (AA) contract. It is designed for networks that don't have native AA and instead work with Alt-Mempools and EntryPoint contracts. It was made for the Advanced Foundry course of Cyfrin Updraft.

<br>

- [Account Abstraction (Ethereum)](#account-abstraction-ethereum)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
- [Usage](#usage)
  - [Libraries](#libraries)
  - [Testing](#testing)
    - [Test Coverage](#test-coverage)
  - [Estimate gas](#estimate-gas)
  - [Formatting](#formatting)
- [Deploy](#deploy)
  - [Private Key Encryption](#private-key-encryption)
  - [Deployment to Arbitrum](#deployment-to-arbitrum)
    - [Deploy](#deploy-1)
    - [Send User Operation](#send-user-operation)
- [Acknowledgments](#acknowledgments)
- [Thank you](#thank-you)

<br>

![EthereumBanner](https://github.com/user-attachments/assets/8a1c6e53-2e66-4256-9312-252a0360b7df)

<br>

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

## Quickstart

```
git clone https://github.com/RicardoPintos/account-abstraction-ethereum
cd account-abstraction-ethereum
forge build
```

<br>

# Usage

## Libraries

This project uses the following libraries:

- [Openzeppelin-contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Cyfrin-foundry-devops](https://github.com/Cyfrin/foundry-devops)
- [Cyfrin-foundry-era-contracts](https://github.com/Cyfrin/foundry-era-contracts)
- [Foundry-forge-std](https://github.com/foundry-rs/forge-std)
- [ETH-Infinitism-AA](https://github.com/eth-infinitism/account-abstraction)

You can install all of them with the following Makefile command:

```
make install
```

## Testing

To run every test:

```
forge test
```

### Test Coverage

To check the test coverage of this project, run:

```
forge coverage
```

## Estimate gas

You can estimate how much gas things cost by running:

```
forge snapshot
```

And you'll see an output file called `.gas-snapshot`

## Formatting

To run code formatting:

```
forge fmt
```

<br>

# Deploy

## Private Key Encryption

It is recommended to work with encrypted private keys. The following method is an example for Anvil. If you want to deploy to other networks, repeat this process with the respective private key and address.

In your local terminal, run this:

```
cast wallet import <Choose_Your_Anvil_Account_Name> --interactive
```

Paste your private key, hit enter and then create a password for that key. 

<br>

Now, you can use the `--account` flag instead of `--private-key`. You'll need to type your password when is needed. To check all of your encrypted keys, run this:

```
cast wallet list
```

<br>

## Deployment to Arbitrum

### Deploy

To deploy to Arbitrum, run this:

```
forge script script/DeployMinimal.s.sol --rpc-url <Valid_Arbitrum_RCP_URL> --account <Your_Encrypted_Private_Key_Account_Name> --broadcast
```

### Send User Operation

To send the user operation, run this:

```
forge script script/SendPackedUserOp.s.sol --rpc-url <Valid_Arbitrum_RCP_URL> --account <Your_Encrypted_Private_Key_Account_Name> --broadcast
```

<br>

# Acknowledgments

Thanks to the Cyfrin Updraft team and to Patrick Collins for their amazing work. Please check out their courses on [Cyfrin Updraft](https://updraft.cyfrin.io/courses).

<br>

# Thank you

If you appreciated this, feel free to follow me!

[![Ricardo Pintos Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=x&logoColor=white)](https://x.com/pintosric)
[![Ricardo Pintos Linkedin](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ricardo-mauro-pintos/)
[![Ricardo Pintos YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@PintosRic)