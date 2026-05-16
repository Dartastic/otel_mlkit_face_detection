// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_mlkit_face_detection_suppression.dart';

const _tracerName = 'dartastic_otel_libs_mlkit_face_detection';

Tracer _tracer() => OTel.tracerProvider().getTracer(_tracerName);

class MlkitFaceDetectionResult {
  const MlkitFaceDetectionResult({
    this.performanceMode,
    this.landmarkMode,
    this.contourMode,
    this.classificationMode,
    this.minFaceSize,
    this.enableTracking,
    this.faceCount,
    this.primaryTrackingId,
    this.primaryLeftEyeOpenProb,
    this.primaryRightEyeOpenProb,
    this.primarySmilingProb,
    this.primaryRotationY,
    this.primaryRotationZ,
    this.inputImageWidth,
    this.inputImageHeight,
    this.inputImageSource,
    this.processingMs,
  });

  /// `fast` / `accurate`.
  final String? performanceMode;

  /// `none` / `all`.
  final String? landmarkMode;
  final String? contourMode;

  /// `none` / `all` — enables `smilingProbability` etc.
  final String? classificationMode;

  /// Relative min face size (0..1).
  final double? minFaceSize;
  final bool? enableTracking;

  final int? faceCount;

  /// First face's `trackingId`.
  final int? primaryTrackingId;

  final double? primaryLeftEyeOpenProb;
  final double? primaryRightEyeOpenProb;
  final double? primarySmilingProb;

  /// Euler Y / Z rotation of the first face.
  final double? primaryRotationY;
  final double? primaryRotationZ;

  final int? inputImageWidth;
  final int? inputImageHeight;
  final String? inputImageSource;

  final int? processingMs;
}

class MlkitFaceDetectionCallResult<T> {
  const MlkitFaceDetectionCallResult({required this.value, this.result});
  final T value;
  final MlkitFaceDetectionResult? result;
}

/// Wraps an ML Kit Face Detection call in a CLIENT span. [operation] is
/// one of `processImage`, `close`.
Future<T> tracedMlkitFaceDetection<T>({
  required String operation,
  required Future<MlkitFaceDetectionCallResult<T>> Function() invoke,
}) async {
  if (mlkitFaceDetectionInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'mlkit_face_detection',
    'rpc.method': operation,
    'mlkit_face_detection.operation': operation,
  };

  final span = _tracer().startSpan(
    'mlkit_face_detection $operation',
    kind: SpanKind.client,
    attributes: OTel.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final res = r.result!;
      final extras = <Attribute<Object>>[];
      if (res.performanceMode != null) {
        extras.add(OTel.attributeString(
          'mlkit_face_detection.performance_mode',
          res.performanceMode!,
        ));
      }
      if (res.landmarkMode != null) {
        extras.add(OTel.attributeString(
          'mlkit_face_detection.landmark_mode',
          res.landmarkMode!,
        ));
      }
      if (res.contourMode != null) {
        extras.add(OTel.attributeString(
          'mlkit_face_detection.contour_mode',
          res.contourMode!,
        ));
      }
      if (res.classificationMode != null) {
        extras.add(OTel.attributeString(
          'mlkit_face_detection.classification_mode',
          res.classificationMode!,
        ));
      }
      if (res.minFaceSize != null) {
        extras.add(OTel.attributeDouble(
          'mlkit_face_detection.min_face_size',
          res.minFaceSize!,
        ));
      }
      if (res.enableTracking != null) {
        extras.add(OTel.attributeBool(
          'mlkit_face_detection.tracking.enabled',
          res.enableTracking!,
        ));
      }
      if (res.faceCount != null) {
        extras.add(OTel.attributeInt(
          'mlkit_face_detection.face.count',
          res.faceCount!,
        ));
      }
      if (res.primaryTrackingId != null) {
        extras.add(OTel.attributeInt(
          'mlkit_face_detection.primary.tracking_id',
          res.primaryTrackingId!,
        ));
      }
      if (res.primaryLeftEyeOpenProb != null) {
        extras.add(OTel.attributeDouble(
          'mlkit_face_detection.primary.left_eye_open_prob',
          res.primaryLeftEyeOpenProb!,
        ));
      }
      if (res.primaryRightEyeOpenProb != null) {
        extras.add(OTel.attributeDouble(
          'mlkit_face_detection.primary.right_eye_open_prob',
          res.primaryRightEyeOpenProb!,
        ));
      }
      if (res.primarySmilingProb != null) {
        extras.add(OTel.attributeDouble(
          'mlkit_face_detection.primary.smiling_prob',
          res.primarySmilingProb!,
        ));
      }
      if (res.primaryRotationY != null) {
        extras.add(OTel.attributeDouble(
          'mlkit_face_detection.primary.rotation_y',
          res.primaryRotationY!,
        ));
      }
      if (res.primaryRotationZ != null) {
        extras.add(OTel.attributeDouble(
          'mlkit_face_detection.primary.rotation_z',
          res.primaryRotationZ!,
        ));
      }
      if (res.inputImageWidth != null) {
        extras.add(OTel.attributeInt(
          'mlkit_face_detection.input.width',
          res.inputImageWidth!,
        ));
      }
      if (res.inputImageHeight != null) {
        extras.add(OTel.attributeInt(
          'mlkit_face_detection.input.height',
          res.inputImageHeight!,
        ));
      }
      if (res.inputImageSource != null) {
        extras.add(OTel.attributeString(
          'mlkit_face_detection.input.source',
          res.inputImageSource!,
        ));
      }
      if (res.processingMs != null) {
        extras.add(OTel.attributeInt(
          'mlkit_face_detection.processing_ms',
          res.processingMs!,
        ));
      }
      if (extras.isNotEmpty) span.addAttributes(OTel.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTel.attributes([
      OTel.attributeString(
        ErrorResource.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
