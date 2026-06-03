import { Type } from 'class-transformer';
import { IsDateString, IsEnum, IsNumber, IsOptional, IsString, Min } from 'class-validator';
import { PaymentMethod, PaymentStatus } from '../../common/enums';

export class UpdatePaymentDto {
  @IsOptional()
  @IsEnum(PaymentMethod)
  payment_method?: PaymentMethod;

  @IsOptional()
  @IsEnum(PaymentStatus)
  transaction_status?: PaymentStatus;

  @IsOptional()
  @IsString()
  payment_reference?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  amount?: number;

  @IsOptional()
  @IsDateString()
  paid_at?: string;
}