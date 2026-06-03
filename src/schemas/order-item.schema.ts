import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';
import { Order } from './order.schema';
import { Product } from './product.schema';

export type OrderItemDocument = HydratedDocument<OrderItem>;

@Schema({ ...defaultSchemaOptions, collection: 'order_items' })
export class OrderItem {
  @Prop({ type: Types.ObjectId, ref: Order.name, required: true })
  order_id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: Product.name, required: true })
  product_id: Types.ObjectId;

  @Prop({ required: true })
  quantity: number;

  @Prop({ required: true })
  price: number;

  @Prop({ required: true })
  subtotal: number;
}

export const OrderItemSchema = SchemaFactory.createForClass(OrderItem);