import { IsUUID } from 'class-validator';

export class GetWordParams {
  @IsUUID()
  id: string;
}
