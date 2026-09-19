# Profitable-contract dataset

The 43 contracts are grouped by the vulnerability mechanism implemented in
their source code.

## Profitable-path audit

All 43 manifest entries have been manually reviewed at the source-code level.
Each entry contains at least one manually reviewed profitable path connected to
its listed vulnerability family, with a net-positive outcome under the required
setup conditions (for example, an initial contract balance, a caller role, a
block value, a token balance, or a required transaction ordering). No missing
profitable path was found in the current release.

The paths may require an initial balance, caller role, block condition, token
state, or transaction ordering. `MANIFEST.csv` is the source inventory, while
this file records the manual profitable-path conclusion.

## Category notes

- `TOD`: reward or winner selection depends on transaction ordering.
- `hash_preimage`: `FindThisHash.sol` pays the caller after a fixed-hash
  preimage.
- `access`: `DelegationVault.sol` exposes owner takeover followed by withdrawal.
- `arithmetic`: integer overflow/underflow changes balances or rewards.
- `bad_randomness`: block-derived values control a reward or lottery result.
- `gasless_send`: unchecked transfer failure affects fund movement.
- `reentrancy`: external value transfer occurs before state reduction.
- `time_manipulation`: timestamps or block time control payout conditions.
- `unsafe_delegatecall`: `Delegation.sol` overwrites owner storage through
  `delegatecall` and then exposes a profitable claim/withdrawal path.
- `unsafe_suicide`: unprotected or insufficiently protected destruction sends
  the contract balance to a caller or beneficiary.
