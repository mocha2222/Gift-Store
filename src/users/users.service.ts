import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { ArtisanStatus, UserRole } from '../common/enums';
import { parseObjectId } from '../common/mongo.util';
import { Artisan, ArtisanDocument } from '../schemas/artisan.schema';
import { User, UserDocument } from '../schemas/user.schema';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    @InjectModel(Artisan.name) private artisanModel: Model<ArtisanDocument>,
  ) {}

  findAll() {
    return this.userModel.find().exec();
  }

  async findOne(id: string) {
    const user = await this.userModel.findById(parseObjectId(id, 'user id'));
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async update(id: string, data: Partial<User>) {
    const existing = await this.userModel.findById(parseObjectId(id, 'user id'));
    if (!existing) throw new NotFoundException('User not found');

    const user = await this.userModel
      .findByIdAndUpdate(parseObjectId(id, 'user id'), data, { new: true })
      .exec();
    if (!user) throw new NotFoundException('User not found');

    if (user.role === UserRole.ARTISAN && existing.role !== UserRole.ARTISAN) {
      const artisan = await this.artisanModel.findOne({ user_id: user._id }).exec();
      if (!artisan) {
        await this.artisanModel.create({
          user_id: user._id,
          shop_name: user.name,
          status: ArtisanStatus.PENDING_SETUP,
        });
      }
    }

    return user;
  }
}
