# Prompt Spec: CreateProduct

## Metadata
- **Project**: `ExampleProject`
- **Module**: `Catalog`
- **Feature**: `CreateProduct`
- **Type**: `Command`
- **Owner**: `ProductTeam`
- **Status**: `Approved`

## Business Goal
Allow authenticated users with the `Catalog.Product.Create` permission to
create a new product in the catalog. The product must have a unique SKU within
the tenant, a valid price in VND (no decimals), and an initial status of
`Draft`.

## Scope
### In Scope
- Accept product name, SKU, price, and optional description.
- Validate uniqueness of SKU within the tenant.
- Enforce minimum price of 1,000 VND.
- Set initial product status to `Draft`.
- Publish `ProductCreatedEto` integration event.

### Out of Scope
- Product images or media upload.
- Product categories or tags.
- Inventory management.

## Inputs
- `CreateProductRequest` DTO:
  - `Name` (string, required, max 200 chars)
  - `Sku` (string, required, max 50 chars, alphanumeric + dashes)
  - `Price` (long, required, minimum 1000, unit: VND đồng)
  - `Description` (string, optional, max 2000 chars)

## Outputs
- `CreateProductResponse` DTO:
  - `Id` (Guid)
  - `Name` (string)
  - `Sku` (string)
  - `Price` (long)
  - `Status` (string, always `Draft`)
  - `CreatedAt` (DateTimeOffset)

## Domain Rules
- SKU must be unique per tenant. Violation throws
  `Catalog:Product:0001` (`SkuAlreadyExists`).
- Price must be >= 1,000 VND. Violation throws
  `Catalog:Product:0002` (`PriceTooLow`).
- Product name must not be empty or whitespace.

## Security And Compliance
- Requires permission: `Catalog.Product.Create`.
- Tenant isolation: product belongs to `ICurrentTenant.Id`.
- No sensitive data in this feature.

## Integration Contracts
- HTTP: `POST /api/catalog/products`
- AppService: `ICatalogAppService.CreateProductAsync(CreateProductRequest)`
- Event: `ProductCreatedEto` published via `IDistributedEventBus` containing
  `ProductId`, `TenantId`, `Sku`, `Price`.

## Data And Persistence
- Entity: `Product` (`FullAuditedEntity<Guid>`) in `Catalog.Domain`.
- Repository: `IProductRepository` (custom, for SKU uniqueness check).
- EF Mapping: `ProductEntityTypeConfiguration` with unique index on
  `(TenantId, Sku)`.
- Migration required for new `Products` table.

## Observability
- Log product creation at `Information` level with `ProductId` and `Sku`.
- No special metrics or alerts for this feature.

## Tests Required
- **Domain.Tests**: `Product_ShouldThrow_WhenSkuIsDuplicate`,
  `Product_ShouldThrow_WhenPriceIsBelow1000`.
- **Application.Tests**: `CreateProduct_ShouldSucceed_WhenInputIsValid`,
  `CreateProduct_ShouldFail_WhenSkuExists`,
  `CreateProduct_ShouldFail_WhenUnauthorized`.
- **HttpApi.Tests**: `POST_Products_ShouldReturn201_WhenValid`,
  `POST_Products_ShouldReturn400_WhenSkuMissing`.

## Acceptance Criteria
- Creating a product with valid data returns 201 with the product DTO.
- Creating a product with a duplicate SKU returns 409 with error code
  `Catalog:Product:0001`.
- Creating a product with price below 1,000 VND returns 400 with error code
  `Catalog:Product:0002`.
- Creating a product without `Catalog.Product.Create` permission returns 403.
- `ProductCreatedEto` is published after successful creation.

## Open Questions
- None.
