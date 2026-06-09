.PHONY: lint test eval policy verify metrics supply-chain init garden principles

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

garden:
	@./scripts/ci/doc_gardening.sh --stale-days 30

principles:
	@./scripts/ci/golden_principles_check.sh

verify: lint test eval policy garden
	@echo "=== Golden Principles Check ==="
	@-./scripts/ci/golden_principles_check.sh
	@echo "Verify completed"

supply-chain:
	@./scripts/supply_chain/generate_baseline.sh
