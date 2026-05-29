import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { MediaType } from '../common/enums';
import { defaultSchemaOptions } from '../common/schema-options';
import { Product } from './product.schema';

export type ProductMediaDocument = HydratedDocument<ProductMedia>;

@Schema({ ...defaultSchemaOptions, collection: 'product_media' })
export class ProductMedia {
  @Prop({ type: Types.ObjectId, ref: Product.name, required: true })
  product_id: Types.ObjectId;

  @Prop({ type: String, enum: MediaType, required: true })
  media_type: MediaType;

  @Prop({ required: true })
  media_url: string;
}

export const ProductMediaSchema = SchemaFactory.createForClass(ProductMedia);
