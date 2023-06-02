import { ConsoleLogger } from '@nestjs/common';
import { DiagConsoleLogger, DiagLogLevel, diag } from '@opentelemetry/api';
import { logs, SeverityNumber, Logger } from '@opentelemetry/api-logs';
import { OTLPLogsExporter } from '@opentelemetry/exporter-logs-otlp-grpc';
import {
  LoggerProvider,
  BatchLogRecordProcessor,
} from '@opentelemetry/sdk-logs';
import {
  detectResourcesSync,
  envDetector,
  processDetector,
} from '@opentelemetry/resources';
import { dockerCGroupV1Detector } from '@opentelemetry/resource-detector-docker';
import { Resource } from '@opentelemetry/resources';
import { SemanticResourceAttributes } from '@opentelemetry/semantic-conventions';
import { Environment } from './environments';

export class OTELLogger extends ConsoleLogger {
  private readonly logger: Logger;

  constructor(context?: string) {
    super(context);

    if (process.env.NODE_ENV === Environment.Development) {
      diag.setLogger(new DiagConsoleLogger(), DiagLogLevel.DEBUG);
    }

    const provider = new LoggerProvider({
      resource: detectResourcesSync({
        detectors: [envDetector, processDetector, dockerCGroupV1Detector],
      }).merge(
        new Resource({
          [SemanticResourceAttributes.SERVICE_NAME]:
            process.env.SERVICE_NAME || 'word-service-1',
        }),
      ),
    });

    provider.addLogRecordProcessor(
      new BatchLogRecordProcessor(
        new OTLPLogsExporter({
          url: process.env.LOG_EXPORTER_URL || 'http://localhost:4317',
        }),
      ),
    );

    logs.setGlobalLoggerProvider(provider);

    this.logger = logs.getLogger(context);
  }

  log(message: string, context?: string) {
    super.log(message, context);

    this.logger.emit({
      severityNumber: SeverityNumber.INFO,
      severityText: 'INFO',
      body: message,
    });
  }
  error(message: string, trace?: string, context?: string) {
    this.logger.emit({
      severityNumber: SeverityNumber.ERROR,
      severityText: 'ERROR',
      body: message,
    });

    super.error(message, trace, context);
  }
  warn(message: string, context?: string) {
    this.logger.emit({
      severityNumber: SeverityNumber.WARN,
      severityText: 'WARN',
      body: message,
    });

    super.warn(message, context);
  }
  debug(message: string, context?: string) {
    this.logger.emit({
      severityNumber: SeverityNumber.DEBUG,
      severityText: 'DEBUG',
      body: message,
    });

    super.debug(message, context);
  }
  verbose(message: string, context?: string) {
    this.logger.emit({
      severityNumber: SeverityNumber.TRACE,
      severityText: 'TRACE',
      body: message,
    });

    super.verbose(message, context);
  }
}
