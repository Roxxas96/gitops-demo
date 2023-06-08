import { Module } from '@nestjs/common';
import { WordService } from './word.service';
import { WordController } from './word.controller';
import { SequelizeModule } from '@nestjs/sequelize';
import { Word } from './entities/word.entity';
import { OpenTelemetryModule } from 'nestjs-otel';
import { HttpModule } from '@nestjs/axios';

@Module({
  imports: [
    SequelizeModule.forFeature([Word]),
    OpenTelemetryModule.forRoot({
      metrics: {
        hostMetrics: true,
        apiMetrics: {
          enable: true,
          defaultAttributes: {
            service: 'word-service',
          },
        },
      },
    }),
    HttpModule.register({
      baseURL: process.env.FORWARD_SERVICE || 'http://localhost:3001',
    }),
  ],
  controllers: [WordController],
  providers: [WordService],
})
export class WordModule {}
