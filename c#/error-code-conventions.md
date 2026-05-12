# Error Code Conventions

## Two Layers of Error Codes

This harness distinguishes **two separate concerns** for error codes:

| Layer | Purpose | Format | Where Defined |
| --- | --- | --- | --- |
| **Internal Domain Error Code** | Thrown inside C# code via `BusinessException` | `{Module}:{Entity}:{NumericCode}` | `{Module}.Domain.Shared/{Module}ErrorCodes.cs` |
| **Public API Error Code** | Returned to HTTP clients in the response body | Project-specific (e.g., `payment_hub.snake_case`) | Project `api-contract-rules.md` |

**Key rule**: Code throws the *internal* error code. ABP middleware or a custom
mapper translates it to the *public* API error code before the response leaves
the server. Clients never see the internal format.

### Mapping Flow

```
Domain / Application Layer          HTTP Pipeline              Client
─────────────────────────────       ──────────────────         ──────────
throw BusinessException             ABP Exception-to-HTTP      JSON body
  code: "PaymentHub:Transaction:0001"  ──► maps to ──►        "payment_hub.transaction_not_found"
  HTTP 404                                                     HTTP 404
```

ABP performs the mapping via `IHttpExceptionStatusCodeFinder` and the module's
error-code-to-HTTP-status configuration. Projects MAY add a custom middleware or
`IExceptionToErrorInfoConverter` to control the public `code` field in the JSON
envelope.

### Project-Specific Overrides

Each project MAY define its own **public API error code format** in its
`api-contract-rules.md`. When a project-specific rule exists, it takes
precedence over the generic format for the public-facing layer (see
`AGENTS.md` — "project-specific rules take precedence").

The **internal domain error code format** (`{Module}:{Entity}:{NumericCode}`)
remains mandatory for all projects unless the project rulebook explicitly
documents an override with justification.

---

## Internal Domain Error Code

### Naming Pattern

Internal error codes follow the format:

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

## End-to-End Example (Internal → Public)

Below is a complete example showing how an internal domain error code maps to a
public API error code for the Catalog module:

```csharp
// 1. Define internal error code in Domain.Shared
public static class CatalogErrorCodes
{
    public const string SkuAlreadyExists = "Catalog:Product:0001";
    public const string PriceTooLow = "Catalog:Product:0002";
}

// 2. Throw in Application/Domain layer
throw new BusinessException(CatalogErrorCodes.SkuAlreadyExists)
    .WithData("sku", request.Sku);
```

```json
// 3. Client receives public API error code (after ABP mapping)
// HTTP 409 Conflict
{
  "error": {
    "code": "catalog.sku_conflict",
    "message": "A product with this SKU already exists.",
    "traceId": "abc123"
  }
}
```

The mapping between `Catalog:Product:0001` (internal) and `catalog.sku_conflict`
(public) is configured in the module's HTTP pipeline — either via ABP's built-in
exception mapping or a custom `IExceptionToErrorInfoConverter`.

## Agent Checklist
- Define error codes in `Domain.Shared` before using them.
- Use the `{Module}:{Entity}:{NumericCode}` format for **internal** codes.
- Reserve numeric ranges per entity to avoid collisions.
- Reference error code constants, never inline strings.
- Map error codes to HTTP status codes in the module configuration or let ABP
  handle defaults.
- Understand that **public API error codes** (client-facing) are a separate
  concern defined in the project's `api-contract-rules.md`.
- When implementing a feature, define both: the internal throw code AND the
  public API code that clients will see.
- Consult the project-specific `api-contract-rules.md` for the public format.
