import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Review, ReviewDocument } from '../schemas/review.schema';

@Injectable()
export class ReviewsService {
  constructor(
    @InjectModel(Review.name) private reviewModel: Model<ReviewDocument>,
  ) {}

  findByProduct(productId: string) {
    return this.reviewModel
      .find({ product_id: parseObjectId(productId, 'product id') })
      .populate('user_id')
      .sort({ createdAt: -1 })
      .exec();
  }

  create(
    userId: string,
    data: {
      product_id: string;
      rating: number;
      comment?: string;
      photo?: string;
    },
  ) {
    return this.reviewModel.create({
      user_id: parseObjectId(userId),
      product_id: parseObjectId(data.product_id, 'product id'),
      rating: data.rating,
      comment: data.comment,
      photo: data.photo,
    });
  }
}
