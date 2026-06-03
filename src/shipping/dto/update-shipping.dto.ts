import { IsDateString, IsEnum, IsOptional, IsString } from 'class-validator';
import { ShippingStatus } from '../../common/enums';

export class UpdateShippingDto {
  @IsOptional()
  @IsString()
  recipient_name?: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  address_line1?: string;

  @IsOptional()
  @IsString()
  address_line2?: string;

  @IsOptional()
  @IsString()
  city?: string;

  @IsOptional()
  @IsString()
  state?: string;

  @IsOptional()
  @IsString()
  postal_code?: string;

  @IsOptional()
  @IsString()
  country?: string;

  @IsOptional()
  @IsString()
  tracking_number?: string;

  @IsOptional()
  @IsString()
  delivery_provider?: string;

  @IsOptional()
  @IsEnum(ShippingStatus)
  shipping_status?: ShippingStatus;

  @IsOptional()
  @IsDateString()
  shipped_at?: string;

  @IsOptional()
  @IsDateString()
  delivered_at?: string;
}