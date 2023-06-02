import { Injectable } from '@nestjs/common';
import { CreateWordDto } from './dto/create-word.dto';
import { UpdateWordDto } from './dto/update-word.dto';
import { InjectModel } from '@nestjs/sequelize';
import { Word } from './entities/word.entity';
import { OtelMethodCounter, Span } from 'nestjs-otel';
import { OTELLogger } from 'src/logger';

export enum WordServiceError {
  WORD_EXISTS = 'Word already exists',
  WORD_NOT_FOUND = 'Word not found',
  WORD_EMPTY = 'Empty word list',
}

@Injectable()
export class WordService {
  private readonly logger = new OTELLogger(WordService.name);

  constructor(
    @InjectModel(Word)
    private readonly wordModel: typeof Word,
  ) {}

  @Span('create word')
  create(createWordDto: CreateWordDto) {
    this.logger.debug(`Creating word: ${createWordDto.word}`);
    return new Promise((resolve, reject) => {
      this.wordModel
        .findOne({
          where: { word: createWordDto.word },
        })
        .then((word) => {
          if (word) {
            this.logger.debug(`Word already exists: ${createWordDto.word}`);
            return reject(Error(WordServiceError.WORD_EXISTS));
          }

          return resolve(this.wordModel.create({ ...createWordDto }));
        })
        .catch((error) => {
          this.logger.error(error.message);
          return reject(error);
        });
    });
  }

  @Span('find all words')
  findAll() {
    this.logger.debug('Finding all words');
    return new Promise((resolve, reject) => {
      this.wordModel
        .findAll()
        .then((words) => {
          return resolve(words);
        })
        .catch((error) => {
          this.logger.error(error.message);
          return reject(error);
        });
    });
  }

  @Span('find one word')
  findOne(id: string) {
    return new Promise((resolve, reject) => {
      this.wordModel
        .findOne({ where: { id } })
        .then((word) => {
          if (!word) {
            this.logger.debug(`Word not found: ${id}`);
            return reject(Error(WordServiceError.WORD_NOT_FOUND));
          }

          return resolve(word);
        })
        .catch((error) => {
          this.logger.error(error.message);
          return reject(error);
        });
    });
  }

  @Span('update word')
  update(id: string, updateWordDto: UpdateWordDto) {
    return new Promise((resolve, reject) => {
      this.wordModel
        .findOne({ where: { id } })
        .then((word) => {
          if (!word) {
            this.logger.debug(`Word not found: ${id}`);
            return reject(Error(WordServiceError.WORD_NOT_FOUND));
          }

          return resolve(word.update(updateWordDto));
        })
        .catch((error) => {
          this.logger.error(error.message);
          return reject(error);
        });
    });
  }

  @Span('remove word')
  remove(id: string) {
    return new Promise((resolve, reject) => {
      this.wordModel
        .findOne({ where: { id } })
        .then((word) => {
          if (!word) {
            this.logger.debug(`Word not found: ${id}`);
            return reject(Error(WordServiceError.WORD_NOT_FOUND));
          }

          return resolve(word.destroy());
        })
        .catch((error) => {
          this.logger.error(error.message);
          return reject(error);
        });
    });
  }

  @Span('find random word')
  @OtelMethodCounter()
  random() {
    return new Promise((resolve, reject) => {
      this.wordModel
        .findOne({ order: [this.wordModel.sequelize.random()] })
        .then((word) => {
          if (!word) {
            this.logger.debug(`Database empty when trying to find random word`);
            return reject(Error(WordServiceError.WORD_EMPTY));
          }

          return resolve(word);
        })
        .catch((error) => {
          this.logger.error(error.message);
          return reject(error);
        });
    });
  }

  @Span('clear words')
  clear() {
    return new Promise((resolve) => {
      this.wordModel
        .destroy({ truncate: true })
        .then(() => {
          return resolve({});
        })
        .catch((error) => {
          this.logger.error(error.message);
          return error;
        });
    });
  }
}
