// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_aws_glue/otel_aws_glue.dart';

/// Traces Aws Glue calls with OpenTelemetry.
///
/// `otel_aws_glue` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Aws Glue call in
/// [tracedAwsGlue]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'aws-glue-example');

  // Traces a Aws Glue call.
  final awsGlueId = await tracedAwsGlue<String>(
    operation: 'create',
    invoke: () async {
      // Make the Aws Glue call here, then report what it returned.
      const id = 'aws_glue_8f3a2c';
      return const AwsGlueCallResult(
          value: id,
          result: AwsGlueResult(
              region: 'us-east-1',
              account: 'example',
              surface: 'example',
              jobName: 'example',
              jobRunId: 'jobrun_8f3a2c',
              jobRunState: 'active',
              workerType: 'standard',
              numberOfWorkers: 1,
              glueVersion: '1',
              executionTimeSec: 1,
              maxCapacityDpu: 0.5,
              dpuSeconds: 0.5,
              crawlerName: 'example',
              crawlerState: 'active',
              tablesUpdated: 1,
              tablesCreated: 1,
              databaseName: 'example',
              tableName: 'orders',
              workflowName: 'example',
              workflowRunId: 'workflowrun_8f3a2c',
              workflowStatus: 'succeeded',
              triggerName: 'example',
              triggerState: 'active',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedAwsGlue create returned $awsGlueId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutAwsGlueInstrumentationAsync.
  await runWithoutAwsGlueInstrumentationAsync(
    () => tracedAwsGlue<String>(
      operation: 'create',
      invoke: () async {
        const id = 'aws_glue_8f3a2c';
        return const AwsGlueCallResult(
            value: id,
            result: AwsGlueResult(
                region: 'us-east-1',
                account: 'example',
                surface: 'example',
                jobName: 'example',
                jobRunId: 'jobrun_8f3a2c',
                jobRunState: 'active',
                workerType: 'standard',
                numberOfWorkers: 1,
                glueVersion: '1',
                executionTimeSec: 1,
                maxCapacityDpu: 0.5,
                dpuSeconds: 0.5,
                crawlerName: 'example',
                crawlerState: 'active',
                tablesUpdated: 1,
                tablesCreated: 1,
                databaseName: 'example',
                tableName: 'orders',
                workflowName: 'example',
                workflowRunId: 'workflowrun_8f3a2c',
                workflowStatus: 'succeeded',
                triggerName: 'example',
                triggerState: 'active',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
