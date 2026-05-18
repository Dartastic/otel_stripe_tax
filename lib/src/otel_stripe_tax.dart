// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_stripe_tax_suppression.dart';

class StripeTaxResult {
  const StripeTaxResult({
    this.calculationId,
    this.transactionId,
    this.country,
    this.state,
    this.postalCode,
    this.taxAmount,
    this.totalAmount,
    this.currency,
    this.behavior,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? calculationId;
  final String? transactionId;
  final String? country;
  final String? state;
  final String? postalCode;
  final double? taxAmount;
  final double? totalAmount;
  final String? currency;
  final String? behavior;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class StripeTaxCallResult<T> {
  const StripeTaxCallResult({required this.value, this.result});
  final T value;
  final StripeTaxResult? result;
}

Future<T> tracedStripeTax<T>({
  required String operation,
  required Future<StripeTaxCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (stripeTaxInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_stripe_tax');
  final span = t.startSpan('stripetax $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'stripe_tax');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.calculationId != null) {
        span.setStringAttribute(
          'stripe_tax.calculation.id',
          res.calculationId!,
        );
      }
      if (res.transactionId != null) {
        span.setStringAttribute(
          'stripe_tax.transaction.id',
          res.transactionId!,
        );
      }
      if (res.country != null) {
        span.setStringAttribute('stripe_tax.country', res.country!);
      }
      if (res.state != null) {
        span.setStringAttribute('stripe_tax.state', res.state!);
      }
      if (res.postalCode != null) {
        span.setStringAttribute('stripe_tax.postal_code', res.postalCode!);
      }
      if (res.taxAmount != null) {
        span.setDoubleAttribute('stripe_tax.amount', res.taxAmount!);
      }
      if (res.totalAmount != null) {
        span.setDoubleAttribute('stripe_tax.total', res.totalAmount!);
      }
      if (res.currency != null) {
        span.setStringAttribute('stripe_tax.currency', res.currency!);
      }
      if (res.behavior != null) {
        span.setStringAttribute('stripe_tax.behavior', res.behavior!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('stripetax.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'stripe_tax.error',
        );
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
