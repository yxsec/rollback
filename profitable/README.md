# Profitable-contract dataset

This directory contains 43 Solidity contracts selected for a profitable
vulnerability study. Each sample has a code-level asset-transfer or
asset-destruction path associated with the reported vulnerability family; the
path may require an initial contract balance, a particular block environment,
a caller role, or a specific transaction sequence.

The dataset is organized by the vulnerability mechanism visible in the source:

| Category | Count |
|---|---:|
| TOD | 3 |
| hash_preimage | 1 |
| access | 1 |
| arithmetic | 4 |
| bad_randomness | 8 |
| gasless_send | 2 |
| reentrancy | 15 |
| time_manipulation | 6 |
| unsafe_delegatecall | 1 |
| unsafe_suicide | 2 |
| **Total** | **43** |

All 43 entries have passed a manual source-level profitable-path review. Each
contains at least one attacker-reachable net-positive path under its required
setup conditions; see `AUDIT.md` for the scope of that conclusion.

Use [MANIFEST.csv](MANIFEST.csv) for the complete public source mapping.
