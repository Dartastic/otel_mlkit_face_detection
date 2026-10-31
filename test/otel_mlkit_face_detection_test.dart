// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_mlkit_face_detection/otel_mlkit_face_detection.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_mlkit_face_detection-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('processImage records face count + primary smile/eye prob', () async {
    await tracedMlkitFaceDetection<String>(
      operation: 'processImage',
      invoke: () async => const MlkitFaceDetectionCallResult(
        value: 'ok',
        result: MlkitFaceDetectionResult(
          performanceMode: 'accurate',
          classificationMode: 'all',
          enableTracking: true,
          faceCount: 2,
          primaryTrackingId: 7,
          primarySmilingProb: 0.91,
          primaryLeftEyeOpenProb: 0.98,
          processingMs: 54,
        ),
      ),
    );
    final a = attrsOf(
      spans.findSpanByName('mlkit_face_detection processImage')!,
    );
    expect(a['mlkit_face_detection.face.count'], 2);
    expect(a['mlkit_face_detection.primary.tracking_id'], 7);
    expect(a['mlkit_face_detection.primary.smiling_prob'], 0.91);
  });

  test('suppression skips spans', () async {
    await runWithoutMlkitFaceDetectionInstrumentationAsync(() async {
      await tracedMlkitFaceDetection<String>(
        operation: 'close',
        invoke: () async => const MlkitFaceDetectionCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('mlkit_face_detection '), isEmpty);
  });
}
