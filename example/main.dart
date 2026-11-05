// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_stripe_tax/otel_stripe_tax.dart';

/// Traces Stripe Tax calls with OpenTelemetry.
///
/// `otel_stripe_tax` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Stripe Tax call in
/// [tracedStripeTax]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'stripe-tax-example');

  // Traces a Stripe Tax call.
  final stripeTaxId = await tracedStripeTax<String>(
    operation: 'create',
    invoke: () async {
      // Make the Stripe Tax call here, then report what it returned.
      const id = 'stripe_tax_8f3a2c';
      return const StripeTaxCallResult(
          value: id,
          result: StripeTaxResult(
              calculationId: 'calculation_8f3a2c',
              transactionId: 'transaction_8f3a2c',
              country: 'example',
              state: 'active',
              postalCode: 'example',
              taxAmount: 0.5,
              totalAmount: 0.5,
              currency: 'usd',
              behavior: 'example',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedStripeTax create returned $stripeTaxId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutStripeTaxInstrumentationAsync.
  await runWithoutStripeTaxInstrumentationAsync(
    () => tracedStripeTax<String>(
      operation: 'create',
      invoke: () async {
        const id = 'stripe_tax_8f3a2c';
        return const StripeTaxCallResult(
            value: id,
            result: StripeTaxResult(
                calculationId: 'calculation_8f3a2c',
                transactionId: 'transaction_8f3a2c',
                country: 'example',
                state: 'active',
                postalCode: 'example',
                taxAmount: 0.5,
                totalAmount: 0.5,
                currency: 'usd',
                behavior: 'example',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
