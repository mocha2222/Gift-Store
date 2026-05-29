import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';
import { Product } from './product.schema';
import { User } from './user.schema';

export type ReviewDocument = HydratedDocument<Review>;

@Schema({ ...defaultSchemaOptions, collection: 'reviews' })
export class Review {
  @Prop({ type: Types.ObjectId, ref: User.name, required: true })
  user_id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: Product.name, required: true })
  product_id: Types.ObjectId;

  @Prop({ required: true, min: 1, max: 5 })
  rating: number;

  @Prop()
  comment?: string;

  @Prop()
  photo?: string;
}

export const ReviewSchema = SchemaFactory.createForClass(Review);
