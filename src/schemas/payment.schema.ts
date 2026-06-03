import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { PaymentMethod, PaymentStatus } from '../common/enums';
import { defaultSchemaOptions } from '../common/schema-options';
import { Order } from './order.schema';

export type PaymentDocument = HydratedDocument<Payment>;

@Schema({ ...defaultSchemaOptions, collection: 'payments' })
export class Payment {
  @Prop({ type: Types.ObjectId, ref: Order.name, required: true, unique: true })
  order_id: Types.ObjectId;

  @Prop({ type: String, enum: PaymentMethod, required: true })
  payment_method: PaymentMethod;

  @Prop({ type: String, enum: PaymentStatus, default: PaymentStatus.PENDING })
  transaction_status: PaymentStatus;

  @Prop()
  payment_reference?: string;

  @Prop({ required: true })
  amount: number;

  @Prop()
  paid_at?: Date;
}

export const PaymentSchema = SchemaFactory.createForClass(Payment);