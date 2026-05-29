import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Favorite, FavoriteDocument } from '../schemas/favorite.schema';

@Injectable()
export class FavoritesService {
  constructor(
    @InjectModel(Favorite.name) private favoriteModel: Model<FavoriteDocument>,
  ) {}

  findByUser(userId: string) {
    return this.favoriteModel
      .find({ user_id: parseObjectId(userId) })
      .populate({ path: 'product_id', populate: ['artisan_id', 'category_id'] })
      .sort({ createdAt: -1 })
      .exec();
  }

  async add(userId: string, productId: string) {
    try {
      return await this.favoriteModel.create({
        user_id: parseObjectId(userId),
        product_id: parseObjectId(productId, 'product id'),
      });
    } catch {
      throw new ConflictException('Already in favorites');
    }
  }

  async remove(userId: string, productId: string) {
    const fav = await this.favoriteModel.findOneAndDelete({
      user_id: parseObjectId(userId),
      product_id: parseObjectId(productId, 'product id'),
    });
    if (!fav) throw new NotFoundException('Favorite not found');
    return { message: 'Removed from favorites' };
  }
}
