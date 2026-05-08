# Error Code Conventions

## Naming Pattern

Error codes follow the format:

```
{Module}:{Entity}:{NumericCode}
```

- **Module**: The ABP module name (e.g., `PaymentHub`, `Catalog`, `Identity`).
- **Entity**: The primary domain entity involved (e.g., `Transaction`,
  `Product`, `Provider`).
- **NumericCode**: A zero-padded 4-digit number unique within the
  Module:Entity scope (e.g., `0001`, `0042`).

Full example: `PaymentHub:Transaction:0001`

## File Location

Error codes MUST be defined as `const string` fields in the
`{Module}.Domain.Shared` project:

```
{Module}.Domain.Shared/
 └── {Module}ErrorCodes.cs
```

Example:

```csharp
namespace Harness.PaymentHub;

public static class PaymentHubErrorCodes
{
    // Transaction errors: 0001–0099
    public const string TransactionNotFound = "PaymentHub:Transaction:0001";
    public const string TransactionAlreadySettled = "PaymentHub:Transaction:0002";
    public const string InvalidStateTransition = "PaymentHub:Transaction:0003";

    // Provider errors: 0100–0199
    public const string ProviderNotRegistered = "PaymentHub:Provider:0100";
    public const string ProviderTimeout = "PaymentHub:Provider:0101";

    // Idempotency errors: 0200–0299
    public const string IdempotencyKeyConflict = "PaymentHub:Idempotency:0200";
    public const string NonceReplay = "PaymentHub:Idempotency:0201";
    public const string TimestampOutOfWindow = "PaymentHub:Idempotency:0202";
}
```

## Numbering Ranges

Reserve numeric ranges per entity or subdomain to avoid collisions:

| Range | Purpose |
| --- | --- |
| `0001–0099` | Core entity errors |
| `0100–0199` | External provider / adapter errors |
| `0200–0299` | Idempotency / concurrency errors |
| `0300–0399` | Security / permission errors |
| `0400–0499` | Validation / contract errors |
| `0500–0999` | Reserved for project-specific expansion |

## HTTP Status Code Mapping

| Error Category | Default HTTP Status |
| --- | --- |
| Entity not found | 404 Not Found |
| Invalid state transition | 409 Conflict |
| Validation failure | 400 Bad Request |
| Idempotency key conflict | 422 Unprocessable Entity |
| Permission / authorization | 403 Forbidden |
| External provider failure | 502 Bad Gateway |
| Timeout | 504 Gateway Timeout |

ABP automatically maps `BusinessException` error codes to HTTP responses via
`IHttpExceptionStatusCodeFinder`. Project-specific mappings can be registered in
the module's `ConfigureServices`.

## Usage in Code

Always throw `BusinessException` with the defined error code:

```csharp
throw new BusinessException(PaymentHubErrorCodes.TransactionNotFound)
    .WithData("transactionId", transactionId);
```

Never use:
- `throw new Exception("...")`
- `throw new ApplicationException("...")`
- Inline string error codes (must reference the `ErrorCodes` class)

## Agent Checklist
- Define error codes in `Domain.Shared` before using them.
- Use the `{Module}:{Entity}:{NumericCode}` format consistently.
- Reserve numeric ranges per entity to avoid collisions.
- Reference error code constants, never inline strings.
- Map error codes to HTTP status codes in the module configuration or let ABP
  handle defaults.
