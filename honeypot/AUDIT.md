# Honeypot dataset audit

This audit records code-level classification. `Strong trap` means the apparent
payout is blocked by a hidden, unreachable, or misleading condition. `Mixed`
means a normal user can still execute at least one public fund-return path in a
funded state, while another advertised or administrative path remains
restricted or asymmetric.

| Contract | Classification | Main issue |
|---|---|---|
| `CryptoRoulette.sol` | Conditional trap | The constructor can choose `secretNumber` in 1--20, but `play()` accepts only `number <= 10`; values 11--20 are impossible to guess. When the value is 1--10, weak block/time randomness still permits a correct guess. |
| `For_Test.sol` | Strong trap | For the advertised `msg.value > 0.1 ether`, the loop bound is `2 * msg.value` in wei, so the payout calculation is practically unreachable because of gas. |
| `GuessNumber.sol` | Conditional trap | The generated value and accepted guess are both in 1--10, so there is no out-of-range guessing trap. However, the owner can set `minBet` to an arbitrarily high value through `changeMinBet()`, making the public guessing path practically inaccessible. |
| `ICO_Hold.sol` | Strong trap | Deposits are recorded, but the inherited owner slot controls withdrawal and the visible owner slot is misleading. |
| `KingOfTheHill.sol` | Strong trap | Derived `owner` shadows `Owned.owner`; the apparent new owner cannot satisfy `onlyOwner`. |
| `MultiplicatorX3.sol` | Strong trap | Because `this.balance` already includes `msg.value`, `msg.value >= this.balance` can hold only when the prior balance is zero; the advertised multiplication path cannot profit from an existing jackpot. |
| `PINCODE.sol` | Strong trap | The balance check includes the current payment, so it cannot pass when the contract already has a positive balance; with an empty balance, the matching code only refunds the caller's payment. |
| `RACEFORETH.sol` | Strong trap | The per-call limit halves from 50 to 25 to 12...; the geometric sum stays below the 100-finney target, so the winning threshold is unreachable. |
| `RichestTakeAll.sol` | Strong trap | Same owner-shadowing trap as `KingOfTheHill`. |
| `TerrionFund.sol` | Mixed | Contributors can exit, but only receive 10%; owner drainage and asymmetric fund behavior remain. |
| `Test1.sol` | Strong trap | The required payout loop is impractical for the required deposit. |
| `TestToken.sol` | Mixed | Normal user withdrawal exists, while `withdrawAll()` has hidden block/owner behavior. |
| `WhaleGiveaway1.sol` | Strong trap | The owner receives the entire balance before the caller transfer, leaving no advertised giveaway for the caller. |
| `X2_FLASH.sol` | Strong trap | The low-level call is not invoked with `()`, so the advertised payout call is not executed. |
