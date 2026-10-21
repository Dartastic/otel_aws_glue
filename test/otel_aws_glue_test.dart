// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_aws_glue/otel_aws_glue.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_aws_glue-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('StartJobRun records worker type + dpu seconds', () async {
    await tracedAwsGlue<String>(
      operation: 'StartJobRun',
      invoke: () async => const AwsGlueCallResult(
        value: 'ok',
        result: AwsGlueResult(
          jobName: 'etl-daily',
          jobRunState: 'RUNNING',
          workerType: 'G.1X',
          numberOfWorkers: 10,
          glueVersion: '4.0',
          dpuSeconds: 1200.5,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('aws_glue StartJobRun')!);
    expect(a['aws.glue.worker.type'], 'G.1X');
    expect(a['aws.glue.worker.count'], 10);
    expect(a['aws.glue.dpu_seconds'], 1200.5);
  });

  test('FAILED job run sets span error', () async {
    await tracedAwsGlue<String>(
      operation: 'GetJobRun',
      invoke: () async => const AwsGlueCallResult(
        value: 'ok',
        result: AwsGlueResult(
          jobName: 'etl-daily',
          jobRunState: 'FAILED',
        ),
      ),
    );
    expect(
      spans.findSpanByName('aws_glue GetJobRun')!.status,
      SpanStatusCode.Error,
    );
  });

  test('Crawler records tables created + updated', () async {
    await tracedAwsGlue<String>(
      operation: 'StartCrawler',
      invoke: () async => const AwsGlueCallResult(
        value: 'ok',
        result: AwsGlueResult(
          crawlerName: 'discover',
          crawlerState: 'READY',
          tablesCreated: 5,
          tablesUpdated: 12,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('aws_glue StartCrawler')!);
    expect(a['aws.glue.tables_created'], 5);
    expect(a['aws.glue.tables_updated'], 12);
  });

  test('suppression skips spans', () async {
    await runWithoutAwsGlueInstrumentationAsync(() async {
      await tracedAwsGlue<String>(
        operation: 'GetJob',
        invoke: () async => const AwsGlueCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('aws_glue '), isEmpty);
  });
}
