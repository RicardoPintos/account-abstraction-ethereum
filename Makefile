-include .env

.PHONY: build test install deploy send

install :; forge install foundry-rs/forge-std@v1.8.2 --no-commit && forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit && forge install eth-infinitism/account-abstraction@v0.7.0 --no-commit && forge install cyfrin/foundry-era-contracts@0.0.3 --no-commit && forge install cyfrin/foundry-devops@0.2.2 --no-commit

build :; forge build

test :; forge test

deploy-arbitrum :; forge script script/DeployMinimal.s.sol --rpc-url ${ARBITRUM_RPC_URL} --account testKey --broadcast -vvvv

send-arbitrum :; forge script script/SendPackedUserOp.s.sol --rpc-url ${ARBITRUM_RPC_URL} --account testKey --broadcast -vvvv