import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { SequelizeModule } from '@nestjs/sequelize';
import { WordModule } from './word/word.module';
import { Dialect } from 'sequelize';

@Module({
  imports: [
    SequelizeModule.forRoot({
      dialect: (process.env.DATABASE_DIALECT as Dialect) || 'postgres',
      host: process.env.DATABASE_HOST || 'localhost',
      port: +process.env.DATABASE_PORT || 5432,
      username: process.env.DATABASE_USERNAME || 'postgres',
      password: process.env.DATABASE_PASSWORD || 'postgres',
      database: process.env.DATABASE_NAME || 'word1',
      autoLoadModels: true,
      synchronize: true,
    }),
    WordModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
