import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { OrderStatus } from '../common/enums';
import { defaultSchemaOptions } from '../common/schema-options';
import { Product } from './product.schema';
import { User } from './user.schema';

@Schema({ _id: true })
export class OrderItem {
  @Prop({ type: Types.ObjectId, ref: Product.name, required: true })
  product_id: Types.ObjectId;

  @Prop({ required: true })
  quantity: number;

  @Prop({ required: true })
  subtotal: number;
}

export const OrderItemSchema = SchemaFactory.createForClass(OrderItem);

export type OrderDocument = HydratedDocument<Order>;

@Schema({ ...defaultSchemaOptions, collection: 'orders' })
export class Order {
  @Prop({ type: Types.ObjectId, ref: User.name, required: true })
  user_id: Types.ObjectId;

  @Prop({ type: [OrderItemSchema], default: [] })
  items: OrderItem[];

  @Prop({ required: true })
  total_price: number;

  @Prop()
  delivery_date?: string;

  @Prop({ default: false })
  gift_wrap: boolean;

  @Prop()
  personal_message?: string;

  @Prop({ type: String, enum: OrderStatus, default: OrderStatus.PENDING })
  status: OrderStatus;

  @Prop()
  coupon_code?: string;
}

export const OrderSchema = SchemaFactory.createForClass(Order);
