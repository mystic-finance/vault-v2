# For convenience, add the following to your aliases:
# `function f() { make forge ARGS="$*"; }`

forge:
	@FOUNDRY_PROFILE=no_via_ir forge $(ARGS)

deploy-fee-wrapper:
	@FOUNDRY_PROFILE=no_via_ir forge create src/periphery/FeeWrapperDeployer.sol:FeeWrapperDeployer \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT) \
		--broadcast

deploy-adapter-factory:
	@FOUNDRY_PROFILE=no_via_ir forge create src/adapters/MorphoVaultV1AdapterFactory.sol:MorphoVaultV1AdapterFactory \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT) \
		--broadcast

# Required variables for create-fee-wrapper:
# DEPLOYER_ADDRESS, FACTORY, ADAPTER_FACTORY, OWNER, SALT, CHILD_VAULT
create-fee-wrapper:
	cast send $(DEPLOYER_ADDRESS) \
		"createFeeWrapper(address,address,address,bytes32,address)" \
		$(FACTORY) $(ADAPTER_FACTORY) $(OWNER) $(SALT) $(CHILD_VAULT) \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

# Required variables for management:
# VAULT, FEE, NAME, SYMBOL
submit-performance-fee:
	cast send $(VAULT) "submit(bytes)" $$(cast calldata "setPerformanceFee(uint256)" $(FEE)) \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

set-performance-fee:
	cast send $(VAULT) "setPerformanceFee(uint256)" $(FEE) \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

set-name:
	cast send $(VAULT) "setName(string)" "$(NAME)" \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

set-symbol:
	cast send $(VAULT) "setSymbol(string)" "$(SYMBOL)" \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

# Required variables for roles/recipients:
# VAULT, RECIPIENT, NEW_OWNER, NEW_CURATOR
submit-performance-fee-recipient:
	cast send $(VAULT) "submit(bytes)" $$(cast calldata "setPerformanceFeeRecipient(address)" $(RECIPIENT)) \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

set-performance-fee-recipient:
	cast send $(VAULT) "setPerformanceFeeRecipient(address)" $(RECIPIENT) \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

set-owner:
	cast send $(VAULT) "setOwner(address)" $(NEW_OWNER) \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

set-curator:
	cast send $(VAULT) "setCurator(address)" $(NEW_CURATOR) \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

.PHONY: forge deploy-fee-wrapper deploy-adapter-factory create-fee-wrapper \
	submit-performance-fee set-performance-fee set-name set-symbol \
	submit-performance-fee-recipient set-performance-fee-recipient set-owner set-curator
