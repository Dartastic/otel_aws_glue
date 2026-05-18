// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_aws_glue_suppression.dart';

class AwsGlueResult {
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

class AwsGlueCallResult<T> {
  const AwsGlueCallResult({required this.value, this.result});
  final T value;
  final AwsGlueResult? result;
}

Future<T> tracedAwsGlue<T>({
  required String operation,
  required Future<AwsGlueCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (awsGlueInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_aws_glue');
  final span = t.startSpan('aws_glue $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'aws-api');
    span.setStringAttribute('rpc.service', 'Glue');
    span.setStringAttribute('rpc.method', operation);
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.region != null) {
        span.setStringAttribute('aws.region', res.region!);
      }
      if (res.account != null) {
        span.setStringAttribute('aws.account.id', res.account!);
      }
      if (res.surface != null) {
        span.setStringAttribute('aws.glue.surface', res.surface!);
      }
      if (res.jobName != null) {
        span.setStringAttribute('aws.glue.job.name', res.jobName!);
      }
      if (res.jobRunId != null) {
        span.setStringAttribute('aws.glue.job.run_id', res.jobRunId!);
      }
      if (res.jobRunState != null) {
        span.setStringAttribute('aws.glue.job.state', res.jobRunState!);
      }
      if (res.workerType != null) {
        span.setStringAttribute('aws.glue.worker.type', res.workerType!);
      }
      if (res.numberOfWorkers != null) {
        span.setIntAttribute('aws.glue.worker.count', res.numberOfWorkers!);
      }
      if (res.glueVersion != null) {
        span.setStringAttribute('aws.glue.version', res.glueVersion!);
      }
      if (res.executionTimeSec != null) {
        span.setIntAttribute(
            'aws.glue.execution_time_sec', res.executionTimeSec!);
      }
      if (res.maxCapacityDpu != null) {
        span.setDoubleAttribute(
            'aws.glue.max_capacity_dpu', res.maxCapacityDpu!);
      }
      if (res.dpuSeconds != null) {
        span.setDoubleAttribute('aws.glue.dpu_seconds', res.dpuSeconds!);
      }
      if (res.crawlerName != null) {
        span.setStringAttribute('aws.glue.crawler.name', res.crawlerName!);
      }
      if (res.crawlerState != null) {
        span.setStringAttribute('aws.glue.crawler.state', res.crawlerState!);
      }
      if (res.tablesUpdated != null) {
        span.setIntAttribute('aws.glue.tables_updated', res.tablesUpdated!);
      }
      if (res.tablesCreated != null) {
        span.setIntAttribute('aws.glue.tables_created', res.tablesCreated!);
      }
      if (res.databaseName != null) {
        span.setStringAttribute('aws.glue.catalog.database', res.databaseName!);
      }
      if (res.tableName != null) {
        span.setStringAttribute('aws.glue.catalog.table', res.tableName!);
      }
      if (res.workflowName != null) {
        span.setStringAttribute('aws.glue.workflow.name', res.workflowName!);
      }
      if (res.workflowRunId != null) {
        span.setStringAttribute('aws.glue.workflow.run_id', res.workflowRunId!);
      }
      if (res.workflowStatus != null) {
        span.setStringAttribute(
            'aws.glue.workflow.status', res.workflowStatus!);
      }
      if (res.triggerName != null) {
        span.setStringAttribute('aws.glue.trigger.name', res.triggerName!);
      }
      if (res.triggerState != null) {
        span.setStringAttribute('aws.glue.trigger.state', res.triggerState!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('aws.glue.error.code', res.errorCode!);
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.jobRunState == 'FAILED' ||
          res.jobRunState == 'TIMEOUT' ||
          res.jobRunState == 'ERROR' ||
          res.crawlerState == 'FAILED' ||
          res.workflowStatus == 'ERROR';
      if (fail) {
        span.setStringAttribute(
            ErrorResource.errorType.key, res.errorCode ?? 'aws_glue.error');
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
