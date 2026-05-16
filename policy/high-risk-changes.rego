package harness.policy

# Input shape (example):
# {
#   "changed_files": ["auth/roles.yml", "docs/readme.md"],
#   "has_manual_approval": false
# }

default deny = false

high_risk_paths := [
  "auth/",
  "billing/",
  "infra/",
  "config/production/",
  "data/delete/"
]

is_high_risk_file(file) {
  some i
  startswith(file, high_risk_paths[i])
}

deny {
  some f
  f := input.changed_files[_]
  is_high_risk_file(f)
  not input.has_manual_approval
}
