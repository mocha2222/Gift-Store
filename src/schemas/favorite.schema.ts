import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';
import { Product } from './product.schema';
import { User } from './user.schema';

export type FavoriteDocument = HydratedDocument<Favorite>;

@Schema({ ...defaultSchemaOptions, collection: 'favorites' })
export class Favorite {
  @Prop({ type: Types.ObjectId, ref: User.name, required: true })
  user_id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: Product.name, required: true })
  product_id: Types.ObjectId;
}

export const FavoriteSchema = SchemaFactory.createForClass(Favorite);
FavoriteSchema.index({ user_id: 1, product_id: 1 }, { unique: true });
