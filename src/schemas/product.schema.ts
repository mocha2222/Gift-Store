import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { defaultSchemaOptions } from '../common/schema-options';
import { Artisan } from './artisan.schema';
import { Category } from './category.schema';

export type ProductDocument = HydratedDocument<Product>;

@Schema({ ...defaultSchemaOptions, collection: 'products' })
export class Product {
  @Prop({ type: Types.ObjectId, ref: Artisan.name, required: true })
  artisan_id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: Category.name, required: true })
  category_id: Types.ObjectId;

  @Prop({ required: true })
  name: string;

  @Prop()
  description?: string;

  @Prop({ required: true })
  price: number;

  @Prop({ default: 0 })
  stock: number;

  @Prop()
  material?: string;

  @Prop()
  // legacy freeform dimensions string (e.g. "10x5x2 cm")
  @Prop()
  dimensions?: string;

  // structured dimension fields (preferred)
  @Prop()
  width?: number;

  @Prop()
  height?: number;

  @Prop()
  depth?: number;

  @Prop()
  unit?: string; // e.g. 'cm', 'in', 'mm'

  @Prop()
  story?: string;

  @Prop()
  image?: string;

  @Prop()
  gift_for?: string;

  @Prop()
  occasion?: string;
}

export const ProductSchema = SchemaFactory.createForClass(Product);
