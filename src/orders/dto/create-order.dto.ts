import { Type } from 'class-transformer';
import {
  IsArray,
  IsBoolean,
  IsDateString,
  IsMongoId,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';

class OrderItemDto {
  @IsMongoId()
  product_id: string;

  @Min(1)
  quantity: number;
}

export class CreateOrderDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => OrderItemDto)
  items: OrderItemDto[];

  @IsOptional()
  @IsDateString()
  delivery_date?: string;

  @IsOptional()
  @IsBoolean()
  gift_wrap?: boolean;

  @IsOptional()
  @IsString()
  personal_message?: string;

  @IsOptional()
  @IsString()
  coupon_code?: string;
}
