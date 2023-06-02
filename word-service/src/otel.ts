import {
  CompositePropagator,
  W3CTraceContextPropagator,
  W3CBaggagePropagator,
} from '@opentelemetry/core';
import { BatchSpanProcessor } from '@opentelemetry/sdk-trace-base';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-grpc';
import { OTLPMetricExporter } from '@opentelemetry/exporter-metrics-otlp-grpc';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { JaegerPropagator } from '@opentelemetry/propagator-jaeger';
import { B3InjectEncoding, B3Propagator } from '@opentelemetry/propagator-b3';
import { PeriodicExportingMetricReader } from '@opentelemetry/sdk-metrics';
import { NodeSDK } from '@opentelemetry/sdk-node';
import { AsyncLocalStorageContextManager } from '@opentelemetry/context-async-hooks';
import { envDetector, processDetector } from '@opentelemetry/resources';
import { dockerCGroupV1Detector } from '@opentelemetry/resource-detector-docker';
import { Resource } from '@opentelemetry/resources';
import { SemanticResourceAttributes } from '@opentelemetry/semantic-conventions';
import * as process from 'process';
import { OTELLogger } from './logger';

const logger = new OTELLogger('Tracing');

const otelSDK = new NodeSDK({
  serviceName: process.env.SERVICE_NAME || 'word-service-1',
  resourceDetectors: [envDetector, processDetector, dockerCGroupV1Detector],
  resource: new Resource({
    [SemanticResourceAttributes.SERVICE_NAME]:
      process.env.SERVICE_NAME || 'word-service-1',
  }),
  metricReader: new PeriodicExportingMetricReader({
    exporter: new OTLPMetricExporter({
      url: process.env.METRIC_EXPORTER_URL || 'http://localhost:4317',
    }),
    exportIntervalMillis: +process.env.METRIC_INTERVAL || 1000,
  }),
  spanProcessor: new BatchSpanProcessor(
    new OTLPTraceExporter({
      url: process.env.TRACE_EXPORTER_URL || 'http://localhost:4317',
    }),
  ),
  contextManager: new AsyncLocalStorageContextManager(),
  textMapPropagator: new CompositePropagator({
    propagators: [
      new JaegerPropagator(),
      new W3CTraceContextPropagator(),
      new W3CBaggagePropagator(),
      new B3Propagator(),
      new B3Propagator({
        injectEncoding: B3InjectEncoding.MULTI_HEADER,
      }),
    ],
  }),
  instrumentations: [getNodeAutoInstrumentations()],
});

export default otelSDK;

// You can also use the shutdown method to gracefully shut down the SDK before process shutdown
// or on some operating system signal.
process.on('SIGTERM', () => {
  otelSDK
    .shutdown()
    .then(
      () => logger.log('SDK shut down successfully'),
      (err) => logger.log('Error shutting down SDK', err),
    )
    .finally(() => process.exit(0));
});
