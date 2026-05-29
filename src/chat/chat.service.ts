import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Chat, ChatDocument } from '../schemas/chat.schema';
import { User, UserDocument } from '../schemas/user.schema';

@Injectable()
export class ChatService {
  constructor(
    @InjectModel(Chat.name) private chatModel: Model<ChatDocument>,
    @InjectModel(User.name) private userModel: Model<UserDocument>,
  ) {}

  getConversation(userId: string, otherUserId: string) {
    const uid = parseObjectId(userId);
    const oid = parseObjectId(otherUserId, 'user id');
    return this.chatModel
      .find({
        $or: [
          { sender_id: uid, receiver_id: oid },
          { sender_id: oid, receiver_id: uid },
        ],
      })
      .populate('sender_id')
      .populate('receiver_id')
      .sort({ sent_at: 1 })
      .exec();
  }

  send(senderId: string, receiverId: string, message: string) {
    return this.chatModel.create({
      sender_id: parseObjectId(senderId),
      receiver_id: parseObjectId(receiverId, 'receiver id'),
      message,
    });
  }

  async listContacts(userId: string) {
    const uid = parseObjectId(userId);
    const chats = await this.chatModel
      .find({ $or: [{ sender_id: uid }, { receiver_id: uid }] })
      .exec();

    const contactIds = new Set<string>();
    for (const c of chats) {
      const sender = c.sender_id.toString();
      const receiver = c.receiver_id.toString();
      const other = sender === uid.toString() ? receiver : sender;
      contactIds.add(other);
    }

    return this.userModel
      .find({ _id: { $in: [...contactIds].map((id) => new Types.ObjectId(id)) } })
      .select('name profile_image role email')
      .exec();
  }
}
