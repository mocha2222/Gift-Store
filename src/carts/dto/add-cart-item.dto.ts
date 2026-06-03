import { Type } from 'class-transformer';
import { IsMongoId, Min } from 'class-validator';

export class AddCartItemDto {
  @IsMongoId()
  product_id: string;

  @Type(() => Number)
  @Min(1)
  quantity: number;
}