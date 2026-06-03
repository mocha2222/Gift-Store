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
  start_date: Date;

  @Prop({ required: true })
  end_date: Date;
}

export const CouponSchema = SchemaFactory.createForClass(Coupon);
