import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { MediaType } from '../common/enums';
import { parseObjectId } from '../common/mongo.util';
import { ProductMedia, ProductMediaDocument } from '../schemas/product-media.schema';

@Injectable()
export class ProductMediaService {
  constructor(
    @InjectModel(ProductMedia.name)
    private mediaModel: Model<ProductMediaDocument>,
  ) {}

  findByProduct(productId: string) {
    return this.mediaModel
      .find({ product_id: parseObjectId(productId, 'product id') })
      .exec();
  }

  create(data: {
    product_id: string;
    media_type: MediaType;
    media_url: string;
  }) {
    return this.mediaModel.create({
      product_id: parseObjectId(data.product_id, 'product id'),
      media_type: data.media_type,
      media_url: data.media_url,
    });
  }
}
