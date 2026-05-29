import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';
import { Collection } from './collection.schema';
import { Product } from './product.schema';

export type CollectionProductDocument = HydratedDocument<CollectionProduct>;

@Schema({ ...defaultSchemaOptions, collection: 'collection_products' })
export class CollectionProduct {
  @Prop({ type: Types.ObjectId, ref: Collection.name, required: true })
  collection_id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: Product.name, required: true })
  product_id: Types.ObjectId;
}

export const CollectionProductSchema = SchemaFactory.createForClass(CollectionProduct);
CollectionProductSchema.index({ collection_id: 1, product_id: 1 }, { unique: true });
