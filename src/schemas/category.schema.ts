import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';

export type CategoryDocument = HydratedDocument<Category>;

@Schema({ ...defaultSchemaOptions, collection: 'categories' })
export class Category {
  @Prop({ required: true })
  category_name: string;

  @Prop()
  image?: string;
}

export const CategorySchema = SchemaFactory.createForClass(Category);
