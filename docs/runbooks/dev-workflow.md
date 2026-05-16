# Dev Workflow（CARD-P1-03）

## Local Commands
- `make lint`
- `make test`
- `make eval`
- `make verify`
- `make metrics`

## CI Alignment
- CI baseline workflow should call `make verify`.
- Metrics script output should be versioned as evidence when needed.
