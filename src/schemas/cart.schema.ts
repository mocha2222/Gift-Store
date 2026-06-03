import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';
import { User } from './user.schema';

export type CartDocument = HydratedDocument<Cart>;

@Schema({ ...defaultSchemaOptions, collection: 'carts' })
export class Cart {
  @Prop({ type: Types.ObjectId, ref: User.name, required: true, unique: true })
  user_id: Types.ObjectId;
}

export const CartSchema = SchemaFactory.createForClass(Cart);