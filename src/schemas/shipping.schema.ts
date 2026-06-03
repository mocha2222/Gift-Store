import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { ShippingStatus } from '../common/enums';
import { defaultSchemaOptions } from '../common/schema-options';
import { Order } from './order.schema';

export type ShippingDocument = HydratedDocument<Shipping>;

@Schema({ ...defaultSchemaOptions, collection: 'shipping' })
export class Shipping {
  @Prop({ type: Types.ObjectId, ref: Order.name, required: true, unique: true })
  order_id: Types.ObjectId;

  @Prop({ required: true })
  recipient_name: string;

  @Prop()
  phone?: string;

  @Prop({ required: true })
  address_line1: string;

  @Prop()
  address_line2?: string;

  @Prop()
  city?: string;

  @Prop()
  state?: string;

  @Prop()
  postal_code?: string;

  @Prop()
  country?: string;

  @Prop()
  tracking_number?: string;

  @Prop()
  delivery_provider?: string;

  @Prop({ type: String, enum: ShippingStatus, default: ShippingStatus.PENDING })
  shipping_status: ShippingStatus;

  @Prop()
  shipped_at?: Date;

  @Prop()
  delivered_at?: Date;
}

export const ShippingSchema = SchemaFactory.createForClass(Shipping);