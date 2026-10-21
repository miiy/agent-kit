# PROJECT.md

> Project-specific rules. Takes precedence over `AGENTS.md`. Write only what is true for this project; never copy universal rules here.

## Overview

- Stack:
- Key directories:
- How to run locally:
- Ports and addresses:

## Project-specific rules

- e.g. the `auth` module may only be called by `gateway`; no reverse dependency.
- e.g. writes to the `orders` table must go through `service/order`, never direct SQL.

## Forbidden

- e.g. never hand-edit anything under `gen/`.

## Verification

```bash
# build / test / local verification commands
```
