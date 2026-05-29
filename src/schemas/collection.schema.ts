import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';
import { Product } from './product.schema';

export type CollectionDocument = HydratedDocument<Collection>;

@Schema({ ...defaultSchemaOptions, collection: 'collections' })
export class Collection {
  @Prop({ required: true })
  title: string;

  @Prop()
  description?: string;

  @Prop()
  cover_image?: string;

}

export const CollectionSchema = SchemaFactory.createForClass(Collection);
