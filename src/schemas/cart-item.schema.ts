import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';
import { Cart } from './cart.schema';
import { Product } from './product.schema';

export type CartItemDocument = HydratedDocument<CartItem>;

@Schema({ ...defaultSchemaOptions, collection: 'cart_items' })
export class CartItem {
  @Prop({ type: Types.ObjectId, ref: Cart.name, required: true })
  cart_id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: Product.name, required: true })
  product_id: Types.ObjectId;

  @Prop({ required: true })
  quantity: number;

  @Prop({ required: true })
  price: number;

  @Prop({ required: true })
  subtotal: number;
}

export const CartItemSchema = SchemaFactory.createForClass(CartItem);
CartItemSchema.index({ cart_id: 1, product_id: 1 }, { unique: true });