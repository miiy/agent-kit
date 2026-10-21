# Makefile: single entry point for this repo (install / release).

SHELL := /bin/bash
VERSION ?=
DIR ?= .
URL ?=
LANG ?=

.PHONY: help install install-local install-submodule install-dry pull tag clean

help: ## show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}{printf "  %-16s %s\n", $$1, $$2}'

install: ## install into a project (clone): make install DIR=/path [URL=git@...] [LANG=zh-CN]
	./install.sh $(if $(URL),--url $(URL),) $(if $(LANG),--lang $(LANG),) "$(DIR)"

install-local: ## install with a symlink to this checkout instead of cloning
	./install.sh --link $(if $(LANG),--lang $(LANG),) "$(DIR)"

install-submodule: ## install as a git submodule instead of a plain clone
	./install.sh --submodule $(if $(URL),--url $(URL),) $(if $(LANG),--lang $(LANG),) "$(DIR)"

install-dry: ## preview the install
	./install.sh --dry-run $(if $(URL),--url $(URL),) $(if $(LANG),--lang $(LANG),) "$(DIR)"

pull: ## update the rules inside a project: make pull DIR=/path
	git -C "$(DIR)/.agent-kit" pull --ff-only

tag: ## create release tag: make tag VERSION=1.1.0
	@test -n "$(VERSION)" || { echo "usage: make tag VERSION=1.1.0"; exit 1; }
	@test -z "$$(git status --porcelain)" || { echo "working tree is dirty, commit first"; exit 1; }
	git tag -a "v$(VERSION)" -m "v$(VERSION)"
	@echo "tagged v$(VERSION) (not pushed; push with: git push origin v$(VERSION))"

clean: ## remove temporary files
	rm -rf __pycache__ .pytest_cache
