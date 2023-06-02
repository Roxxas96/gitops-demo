import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  HttpException,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { WordService, WordServiceError } from './word.service';
import { CreateWordDto } from './dto/create-word.dto';
import { UpdateWordDto } from './dto/update-word.dto';
import { DeleteWordParams } from './params/delete-word.params';
import { GetWordParams } from './params/get-word.params';
import { UpdateWordParams } from './params/update-word.params';

@Controller('word')
export class WordController {
  constructor(private readonly wordService: WordService) {}

  @Post()
  @HttpCode(201)
  create(@Body() createWordDto: CreateWordDto) {
    return new Promise((resolve, reject) => {
      this.wordService
        .create(createWordDto)
        .then((word) => {
          return resolve({ data: word });
        })
        .catch((error) => {
          switch (error.message) {
            case WordServiceError.WORD_EXISTS:
              return reject(
                new HttpException('Word already exists', HttpStatus.CONFLICT),
              );
          }

          return reject(
            new HttpException(
              'Internal Server Error',
              HttpStatus.INTERNAL_SERVER_ERROR,
            ),
          );
        });
    });
  }

  @Get()
  findAll() {
    return new Promise((resolve, reject) => {
      this.wordService
        .findAll()
        .then((words) => {
          return resolve({ data: words });
        })
        .catch(() => {
          return reject(
            new HttpException(
              'Internal Server Error',
              HttpStatus.INTERNAL_SERVER_ERROR,
            ),
          );
        });
    });
  }

  @Get(':id')
  findOne(@Param() params: GetWordParams) {
    return new Promise((resolve, reject) => {
      this.wordService
        .findOne(params.id)
        .then((word) => {
          return { data: word };
        })
        .catch((error) => {
          switch (error.message) {
            case WordServiceError.WORD_NOT_FOUND:
              return reject(
                new HttpException('Word not found', HttpStatus.NOT_FOUND),
              );
          }

          return reject(
            new HttpException(
              'Internal Server Error',
              HttpStatus.INTERNAL_SERVER_ERROR,
            ),
          );
        });
    });
  }

  @Patch(':id')
  update(
    @Param() params: UpdateWordParams,
    @Body() updateWordDto: UpdateWordDto,
  ) {
    return new Promise((resolve, reject) => {
      this.wordService
        .update(params.id, updateWordDto)
        .then((word) => {
          return resolve({ data: word });
        })
        .catch((error) => {
          switch (error.message) {
            case WordServiceError.WORD_NOT_FOUND:
              return reject(
                new HttpException('Word not found', HttpStatus.NOT_FOUND),
              );
          }

          return reject(
            new HttpException(
              'Internal Server Error',
              HttpStatus.INTERNAL_SERVER_ERROR,
            ),
          );
        });
    });
  }

  @Delete(':id')
  remove(@Param() params: DeleteWordParams) {
    return new Promise((resolve, reject) => {
      this.wordService
        .remove(params.id)
        .then((word) => {
          return resolve({ data: word });
        })
        .catch((error) => {
          switch (error.message) {
            case WordServiceError.WORD_NOT_FOUND:
              return reject(
                new HttpException('Word not found', HttpStatus.NOT_FOUND),
              );
          }

          return reject(
            new HttpException(
              'Internal Server Error',
              HttpStatus.INTERNAL_SERVER_ERROR,
            ),
          );
        });
    });
  }

  @Post('clear')
  @HttpCode(204)
  clear() {
    return new Promise((resolve, reject) => {
      this.wordService
        .clear()
        .then(() => {
          return resolve({});
        })
        .catch(() => {
          return reject(
            new HttpException(
              'Internal Server Error',
              HttpStatus.INTERNAL_SERVER_ERROR,
            ),
          );
        });
    });
  }

  @Post('random')
  @HttpCode(200)
  random() {
    return new Promise((resolve, reject) => {
      this.wordService
        .random()
        .then((word) => {
          return resolve({ data: word });
        })
        .catch((error) => {
          switch (error.message) {
            case WordServiceError.WORD_EMPTY:
              return reject(
                new HttpException('Word list empty', HttpStatus.NOT_FOUND),
              );
          }

          return reject(
            new HttpException(
              'Internal Server Error',
              HttpStatus.INTERNAL_SERVER_ERROR,
            ),
          );
        });
    });
  }
}
