import { Module } from '@nestjs/common';
import { WordService } from './word.service';
import { WordController } from './word.controller';
import { SequelizeModule } from '@nestjs/sequelize';
import { Word } from './entities/word.entity';

@Module({
  imports: [SequelizeModule.forFeature([Word])],
  controllers: [WordController],
  providers: [WordService],
})
export class WordModule {}
