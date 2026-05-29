import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { jsonTransform } from '../common/schema-options';
import { User } from './user.schema';

export type ChatDocument = HydratedDocument<Chat>;

@Schema({
  collection: 'chats',
  timestamps: { createdAt: 'sent_at', updatedAt: false },
  toJSON: { virtuals: true, versionKey: false, transform: jsonTransform },
})
export class Chat {
  @Prop({ type: Types.ObjectId, ref: User.name, required: true })
  sender_id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: User.name, required: true })
  receiver_id: Types.ObjectId;

  @Prop({ required: true })
  message: string;
}

export const ChatSchema = SchemaFactory.createForClass(Chat);
