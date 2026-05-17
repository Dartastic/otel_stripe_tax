# Changelog

## [0.1.0-beta.1-wip]

### Added

- Initial release.
- `tracedStripeTax<T>(...)` — wraps a otel_stripe_tax call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutStripeTaxInstrumentation()` / `Async()`.
