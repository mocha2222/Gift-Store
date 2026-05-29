import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';

export type CouponDocument = HydratedDocument<Coupon>;

@Schema({ ...defaultSchemaOptions, collection: 'coupons' })
export class Coupon {
  @Prop({ required: true, unique: true, uppercase: true, trim: true })
  code: string;

  @Prop({ required: true })
  discount: number;

  @Prop({ required: true })
  start_date: string;

  @Prop({ required: true })
  end_date: string;
}

export const CouponSchema = SchemaFactory.createForClass(Coupon);
