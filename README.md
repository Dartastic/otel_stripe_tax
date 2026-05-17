# otel_stripe_tax

Dartastic OpenTelemetry bridge for Stripe Tax (sales tax automation).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_stripe_tax/otel_stripe_tax.dart';

await tracedStripeTax<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return StripeTaxCallResult(value: r, result: StripeTaxResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutStripeTaxInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
