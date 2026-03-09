-include .env

build:; forge build

deploy-fundMe-sepolia:
	forge script script/DeployerFundMe.s.sol:DeployerFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv


anvil:; anvil

deploy-fundMe-anvil:
	forge script script/DeployerFundMe.s.sol:DeployerFundMe --rpc-url http://127.0.0.1:8545 --private-key $(ANVIL_PRIVATE_KEY) --broadcast -vvvv

