// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_stripe_tax/otel_stripe_tax.dart';
import 'package:test/test.dart';

void main() {
  group('otel_stripe_tax', () {
    test('suppression toggles in zone', () async {
      expect(stripeTaxInstrumentationSuppressed(), isFalse);
      await runWithoutStripeTaxInstrumentationAsync(() async {
        expect(stripeTaxInstrumentationSuppressed(), isTrue);
      });
      expect(stripeTaxInstrumentationSuppressed(), isFalse);
    });

    test('StripeTaxResult fields default null', () {
      const r = StripeTaxResult();
      expect(r.statusCode, isNull);
    });
  });
}
