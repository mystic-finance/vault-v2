# For convenience, add the following to your aliases:
# `function f() { make forge ARGS="$*"; }`

forge:
	@FOUNDRY_PROFILE=no_via_ir forge $(ARGS)

deploy-fee-wrapper:
	@FOUNDRY_PROFILE=no_via_ir forge create src/periphery/FeeWrapperDeployer.sol:FeeWrapperDeployer \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

# Required variables for create-fee-wrapper:
# DEPLOYER_ADDRESS, FACTORY, ADAPTER_FACTORY, OWNER, SALT, CHILD_VAULT
create-fee-wrapper:
	cast send $(DEPLOYER_ADDRESS) \
		"createFeeWrapper(address,address,address,bytes32,address)" \
		$(FACTORY) $(ADAPTER_FACTORY) $(OWNER) $(SALT) $(CHILD_VAULT) \
		--rpc-url $(RPC_URL) \
		--account $(ACCOUNT)

.PHONY: forge deploy-fee-wrapper create-fee-wrapper
