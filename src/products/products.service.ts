import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { FilterQuery, Model } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Category, CategoryDocument } from '../schemas/category.schema';
import { Product, ProductDocument } from '../schemas/product.schema';
import { ProductMedia, ProductMediaDocument } from '../schemas/product-media.schema';
import { Review, ReviewDocument } from '../schemas/review.schema';

@Injectable()
export class ProductsService {
  constructor(
    @InjectModel(Product.name) private productModel: Model<ProductDocument>,
    @InjectModel(Category.name) private categoryModel: Model<CategoryDocument>,
    @InjectModel(ProductMedia.name)
    private mediaModel: Model<ProductMediaDocument>,
    @InjectModel(Review.name) private reviewModel: Model<ReviewDocument>,
  ) {}

  async findAll(filters?: {
    category_id?: string;
    artisan_id?: string;
  }): Promise<Record<string, unknown>[]> {
    const query: FilterQuery<Product> = {};
    if (filters?.category_id) {
      query.category_id = parseObjectId(filters.category_id);
    }
    if (filters?.artisan_id) {
      query.artisan_id = parseObjectId(filters.artisan_id);
    }

    const products = await this.productModel
      .find(query)
      .populate('artisan_id')
      .populate('category_id')
      .exec();

    const withMedia = await Promise.all(
      products.map(async (p) => {
        const media = await this.mediaModel.find({ product_id: p._id }).exec();
        return { ...p.toJSON(), media };
      }),
    );
    return withMedia;
  }

  async findOne(id: string): Promise<Record<string, unknown>> {
    const product = await this.productModel
      .findById(parseObjectId(id, 'product id'))
      .populate({ path: 'artisan_id', populate: { path: 'user_id' } })
      .populate('category_id')
      .exec();
    if (!product) throw new NotFoundException('Product not found');

    const [media, reviews] = await Promise.all([
      this.mediaModel.find({ product_id: product._id }).exec(),
      this.reviewModel
        .find({ product_id: product._id })
        .populate('user_id')
        .sort({ createdAt: -1 })
        .exec(),
    ]);

    return { ...product.toJSON(), media, reviews };
  }

  findFeatured() {
    return this.productModel
      .find()
      .populate('artisan_id')
      .populate('category_id')
      .sort({ createdAt: -1 })
      .limit(8)
      .exec();
  }

  async giftFinder(filters: {
    recipient?: string;
    occasion?: string;
    budget?: string;
    style?: string;
  }) {
    const and: FilterQuery<Product>[] = [];

    if (filters.recipient) {
      and.push({
        $or: [
          { gift_for: filters.recipient },
          { gift_for: { $exists: false } },
          { gift_for: null },
        ],
      });
    }
    if (filters.occasion) {
      and.push({
        $or: [
          { occasion: filters.occasion },
          { occasion: { $exists: false } },
          { occasion: null },
        ],
      });
    }

    const query: FilterQuery<Product> = and.length ? { $and: and } : {};
    if (filters.budget === 'under25') query.price = { $lt: 25 };
    else if (filters.budget === '25to75') query.price = { $gte: 25, $lte: 75 };
    else if (filters.budget === 'over75') query.price = { $gt: 75 };

    let products = await this.productModel
      .find(query)
      .populate('category_id')
      .populate('artisan_id')
      .limit(24)
      .exec();

    if (filters.style) {
      products = products.filter((p) => {
        const cat = p.category_id as unknown as Category;
        return (
          cat &&
          typeof cat === 'object' &&
          'category_name' in cat &&
          cat.category_name
            ?.toLowerCase()
            .includes(filters.style!.toLowerCase())
        );
      });
    }

    return products.slice(0, 12);
  }

  create(data: Partial<Product>) {
    return this.productModel.create(data);
  }
}
