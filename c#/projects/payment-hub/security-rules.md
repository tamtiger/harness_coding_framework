# Payment Hub: Security & Compliance Rules

## Scope Statement (CTO Mandate)
- Payment Hub is ONLY an orchestration/integration layer.
- **MUST NOT** hold merchant/customer funds or perform settlement.
- **MUST NOT** store `full PAN`, `CVV`, `track data`, `PIN block`, or `HSM key material`. Tokenization pass-through only.
- PCI Scope: SAQ A (redirect/hosted) or SAQ A-EP (SDK).

## Data Classification & Encryption
- **Transaction Metadata**: Confidential. Encrypted at rest (TDE + AES-256). 5 years retention.
- **Provider Credentials**: Restricted. Encrypted via KMS envelope (Vault/Azure Key Vault). DEK rotation ≤ 90 days. Break-glass SOP requires CTO + Security approval.
- **Customer PII**: Confidential. AES-256 encryption. Retention per tenant rules.
- **Webhook Raw Data**: Internal. TDE. 90 days retention (redacted).
- **Audit Logs**: Confidential. TDE. 5 years retention.

## Tenant Isolation
- **Database Level**: Tenant filtering (Row-Level Security). Tenant A cannot access Tenant B data.
- **Property-based test**: Must enforce `∀ query(A) → 0 records of B` (tested 10K runs in CI).
- **Confused Deputy**: API key of Tenant A requesting with `tenantId=B` must result in HTTP 403.
- Rate limiting must be isolated per tenant.

## Communication Security
- TLS 1.2+ for all connections.
- Outbound Webhooks (Tenant Notifier) must be signed, sent from static outbound IPs, and follow schema versioning (`X-PaymentHub-Version`).
- Inbound Webhooks must validate signature, nonce, timestamp, and IP whitelist.
