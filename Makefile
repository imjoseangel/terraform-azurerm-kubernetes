.POSIX:

.PHONY: all
all: format validate

.PHONY: format
format:
	terraform fmt

.PHONY: validate
validate:
	terraform fmt --check
	terraform init
	terraform validate -no-color
