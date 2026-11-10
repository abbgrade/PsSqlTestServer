# Architecture Decision Records

This directory records significant architectural decisions for PsSqlTestServer.
Each record captures one decision, its context, meaningful alternatives, and
material consequences. Existing records may be reconstructed from the current
implementation when the original rationale was not recorded; they do not imply
that a historical discussion took place.

## Contributing

- Add a record for a significant architectural choice, not every implementation
  detail.
- Copy [the ADR template](./adr-template.md), use the next four-digit number,
  and choose a short kebab-case filename.
- Keep each record focused. Link to relevant source files as evidence, and
  distinguish observed behavior from inferred rationale.
- Preserve the decision history. When a decision changes, add a new ADR that
  links to the previous record rather than rewriting it.
- Add every record to the list below in numerical order.

## Decisions

- [0001: Prefer available local providers for automatic instance creation](./0001-local-provider-selection.md)
- [0002: Keep provider integrations optional and share SQL connection metadata](./0002-optional-provider-integrations.md)
- [0003: Use unique-by-default names for test resources](./0003-unique-test-resource-names.md)
- [0004: Select Docker images and readiness checks by host architecture](./0004-docker-platform-support.md)
- [0005: Use Entra-only authentication for Azure SQL test servers](./0005-azure-sql-authentication.md)
