// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_mlkit_face_detection/otel_mlkit_face_detection.dart';

/// Traces ML Kit Face Detection calls with OpenTelemetry.
///
/// `otel_mlkit_face_detection` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each ML Kit Face Detection call in
/// [tracedMlkitFaceDetection]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'mlkit-face-detection-example');

  // Wraps an ML Kit Face Detection call in a CLIENT span.
  final mlkitFaceDetectionId = await tracedMlkitFaceDetection<String>(
    operation: 'create',
    invoke: () async {
      // Make the ML Kit Face Detection call here, then report what it returned.
      const id = 'mlkit_face_detection_8f3a2c';
      return const MlkitFaceDetectionCallResult(
          value: id,
          result: MlkitFaceDetectionResult(
              performanceMode: 'fast',
              landmarkMode: 'none',
              contourMode: 'example',
              classificationMode: 'none',
              minFaceSize: 0.5,
              enableTracking: true,
              faceCount: 3,
              primaryTrackingId: 1,
              primaryLeftEyeOpenProb: 0.5,
              primaryRightEyeOpenProb: 0.5,
              primarySmilingProb: 0.5,
              primaryRotationY: 0.5,
              primaryRotationZ: 0.5,
              inputImageWidth: 1,
              inputImageHeight: 1,
              inputImageSource: 'example',
              processingMs: 120));
    },
  );
  OTelLog.info(
      'tracedMlkitFaceDetection create returned $mlkitFaceDetectionId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutMlkitFaceDetectionInstrumentationAsync.
  await runWithoutMlkitFaceDetectionInstrumentationAsync(
    () => tracedMlkitFaceDetection<String>(
      operation: 'create',
      invoke: () async {
        const id = 'mlkit_face_detection_8f3a2c';
        return const MlkitFaceDetectionCallResult(
            value: id,
            result: MlkitFaceDetectionResult(
                performanceMode: 'fast',
                landmarkMode: 'none',
                contourMode: 'example',
                classificationMode: 'none',
                minFaceSize: 0.5,
                enableTracking: true,
                faceCount: 3,
                primaryTrackingId: 1,
                primaryLeftEyeOpenProb: 0.5,
                primaryRightEyeOpenProb: 0.5,
                primarySmilingProb: 0.5,
                primaryRotationY: 0.5,
                primaryRotationZ: 0.5,
                inputImageWidth: 1,
                inputImageHeight: 1,
                inputImageSource: 'example',
                processingMs: 120));
      },
    ),
  );

  await OTel.shutdown();
}
