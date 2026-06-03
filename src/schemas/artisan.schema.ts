import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { ArtisanStatus } from '../common/enums';
import { defaultSchemaOptions } from '../common/schema-options';
import { User } from './user.schema';

export type ArtisanDocument = HydratedDocument<Artisan>;

@Schema({ ...defaultSchemaOptions, collection: 'artisans' })
export class Artisan {
  @Prop({ type: Types.ObjectId, ref: User.name, required: true, unique: true })
  user_id: Types.ObjectId;

  @Prop({ type: String, enum: ArtisanStatus, default: ArtisanStatus.PENDING_SETUP })
  status: ArtisanStatus;

  @Prop({ required: true })
  shop_name: string;

  @Prop()
  region?: string;

  @Prop()
  craft_type?: string;

  @Prop()
  story?: string;

  @Prop()
  shop_location?: string;

  @Prop()
  latitude?: number;

  @Prop()
  longitude?: number;

  @Prop()
  cover_image?: string;
}

export const ArtisanSchema = SchemaFactory.createForClass(Artisan);
