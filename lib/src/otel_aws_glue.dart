// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_aws_glue_suppression.dart';

class AwsGlueResult {
  /// Creates a result.
  const AwsGlueResult({
    this.region,
    this.account,
    this.surface,
    this.jobName,
    this.jobRunId,
    this.jobRunState,
    this.workerType,
    this.numberOfWorkers,
    this.glueVersion,
    this.executionTimeSec,
    this.maxCapacityDpu,
    this.dpuSeconds,
    this.crawlerName,
    this.crawlerState,
    this.tablesUpdated,
    this.tablesCreated,
    this.databaseName,
    this.tableName,
    this.workflowName,
    this.workflowRunId,
    this.workflowStatus,
    this.triggerName,
    this.triggerState,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? region;
  final String? account;
  final String? surface;
  final String? jobName;
  final String? jobRunId;
  final String? jobRunState;
  final String? workerType;
  final int? numberOfWorkers;
  final String? glueVersion;
  final int? executionTimeSec;
  final double? maxCapacityDpu;
  final double? dpuSeconds;
  final String? crawlerName;
  final String? crawlerState;
  final int? tablesUpdated;
  final int? tablesCreated;
  final String? databaseName;
  final String? tableName;
  final String? workflowName;
  final String? workflowRunId;
  final String? workflowStatus;
  final String? triggerName;
  final String? triggerState;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class AwsGlueCallResult<T> {
  /// Creates a call result.
  const AwsGlueCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final AwsGlueResult? result;
}

Future<T> tracedAwsGlue<T>({
  required String operation,
  required Future<AwsGlueCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (awsGlueInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_aws_glue');
  final span = t.startSpan('aws_glue $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'aws-api')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.service', 'Glue')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.region != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.region', res.region!)]));
      }
      if (res.account != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.account.id', res.account!)]));
      }
      if (res.surface != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.glue.surface', res.surface!)]));
      }
      if (res.jobName != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.glue.job.name', res.jobName!)]));
      }
      if (res.jobRunId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.glue.job.run_id', res.jobRunId!)]));
      }
      if (res.jobRunState != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.glue.job.state', res.jobRunState!)]));
      }
      if (res.workerType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.glue.worker.type', res.workerType!)
        ]));
      }
      if (res.numberOfWorkers != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('aws.glue.worker.count', res.numberOfWorkers!)
        ]));
      }
      if (res.glueVersion != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.glue.version', res.glueVersion!)]));
      }
      if (res.executionTimeSec != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'aws.glue.execution_time_sec', res.executionTimeSec!)
        ]));
      }
      if (res.maxCapacityDpu != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeDouble(
              'aws.glue.max_capacity_dpu', res.maxCapacityDpu!)
        ]));
      }
      if (res.dpuSeconds != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeDouble('aws.glue.dpu_seconds', res.dpuSeconds!)
        ]));
      }
      if (res.crawlerName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.glue.crawler.name', res.crawlerName!)
        ]));
      }
      if (res.crawlerState != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.glue.crawler.state', res.crawlerState!)
        ]));
      }
      if (res.tablesUpdated != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('aws.glue.tables_updated', res.tablesUpdated!)
        ]));
      }
      if (res.tablesCreated != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('aws.glue.tables_created', res.tablesCreated!)
        ]));
      }
      if (res.databaseName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'aws.glue.catalog.database', res.databaseName!)
        ]));
      }
      if (res.tableName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.glue.catalog.table', res.tableName!)
        ]));
      }
      if (res.workflowName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.glue.workflow.name', res.workflowName!)
        ]));
      }
      if (res.workflowRunId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'aws.glue.workflow.run_id', res.workflowRunId!)
        ]));
      }
      if (res.workflowStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'aws.glue.workflow.status', res.workflowStatus!)
        ]));
      }
      if (res.triggerName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.glue.trigger.name', res.triggerName!)
        ]));
      }
      if (res.triggerState != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.glue.trigger.state', res.triggerState!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.glue.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.jobRunState == 'FAILED' ||
          res.jobRunState == 'TIMEOUT' ||
          res.jobRunState == 'ERROR' ||
          res.crawlerState == 'FAILED' ||
          res.workflowStatus == 'ERROR';
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'aws_glue.error')
        ]));
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
