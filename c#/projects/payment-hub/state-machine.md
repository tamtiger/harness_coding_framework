# Payment Hub: State Machine Rules

## Canonical States
- `Created`: Initial state after receiving request.
- `PendingAuthorize`: Waiting for provider/user authorization.
- `Authorized`: Payment authorized but not yet captured.
- `Captured`: Money successfully deducted.
- `Settled`: Final terminal state for successful payment.
- `Failed`: Terminal state for failed attempts.
- `Cancelled`: Terminal state for user/system cancellation.
- `Refunding`: Partial/Full refund in progress.
- `Refunded`: Terminal state for refund.

## Transition Rules
1. **Valid Transitions**:
   - `Created` → `{PendingAuthorize, Failed, Cancelled}`
   - `PendingAuthorize` → `{Authorized, Captured, Failed, Cancelled}`
   - `Authorized` → `{Captured, Failed, Cancelled}`
   - `Captured` → `{Refunding, Settled}`
   - `Refunding` → `{Refunded, Failed}`
2. **Immutable Terminal States**: Once a transaction reaches `Settled`, `Failed`, `Cancelled`, or `Refunded`, NO further transitions are allowed.
3. **Provider Mapping**: Every Adapter MUST implement `MapProviderStatus` to translate provider-specific codes to these canonical states.
4. **Deposit Failure**: Internal deposit failure after authorization MUST emit `DepositFailed` and trigger provider refund, then transition to `Failed`.

## Implementation Explicitness
- Use Event Sourcing. Every state change MUST be recorded as an immutable event in the Transaction Store (`EventType`, `EventData`, `Source`, `OccurredAt`, `CorrelationId`).
- Publish events to Event Bus (Kafka) via Outbox pattern in the same DB transaction.
