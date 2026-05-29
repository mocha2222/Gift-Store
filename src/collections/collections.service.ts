import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Collection, CollectionDocument } from '../schemas/collection.schema';
import {
  CollectionProduct,
  CollectionProductDocument,
} from '../schemas/collection-product.schema';
import { Product, ProductDocument } from '../schemas/product.schema';

@Injectable()
export class CollectionsService {
  constructor(
    @InjectModel(Collection.name)
    private collectionModel: Model<CollectionDocument>,
    @InjectModel(CollectionProduct.name)
    private collectionProductModel: Model<CollectionProductDocument>,
    @InjectModel(Product.name) private productModel: Model<ProductDocument>,
  ) {}

  findAll() {
    return this.collectionModel.find().exec();
  }

  async findOne(id: string): Promise<Record<string, unknown>> {
    const collection = await this.collectionModel.findById(
      parseObjectId(id, 'collection id'),
    );
    if (!collection) throw new NotFoundException('Collection not found');

    const links = await this.collectionProductModel
      .find({ collection_id: collection._id })
      .select('product_id')
      .exec();

    const productIds = links.map((l) => l.product_id);

    const products = await this.productModel
      .find({ _id: { $in: productIds } })
      .populate('artisan_id')
      .populate('category_id')
      .exec();

    return { ...collection.toJSON(), products };
  }

  async addProduct(collectionId: string, productId: string) {
    const collection = await this.collectionModel.findById(
      parseObjectId(collectionId, 'collection id'),
    );
    if (!collection) throw new NotFoundException('Collection not found');

    // create link in join collection (idempotent due to unique index)
    await this.collectionProductModel.create({
      collection_id: parseObjectId(collectionId, 'collection id'),
      product_id: parseObjectId(productId, 'product id'),
    });

    return collection;
  }

  create(data: Partial<Collection>) {
    return this.collectionModel.create(data);
  }
}
