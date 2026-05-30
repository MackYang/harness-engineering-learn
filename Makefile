.PHONY: lint test eval policy verify metrics supply-chain init

init:
	@./scripts/harness/init.sh

lint:
	@./scripts/ci/lint.sh

test:
	@./scripts/ci/test.sh

eval:
	@./scripts/ci/eval.sh

policy:
	@./scripts/ci/policy_check.sh

metrics:
	@./scripts/metrics/collect_metrics.sh

verify: lint test eval policy
	@echo "Verify completed"

supply-chain:
	@./scripts/supply_chain/generate_baseline.sh
