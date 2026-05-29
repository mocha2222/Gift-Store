import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Artisan, ArtisanDocument } from '../schemas/artisan.schema';
import { Category, CategoryDocument } from '../schemas/category.schema';
import { Collection, CollectionDocument } from '../schemas/collection.schema';
import { Product, ProductDocument } from '../schemas/product.schema';

@Injectable()
export class HomeService {
  constructor(
    @InjectModel(Category.name) private categoryModel: Model<CategoryDocument>,
    @InjectModel(Collection.name)
    private collectionModel: Model<CollectionDocument>,
    @InjectModel(Product.name) private productModel: Model<ProductDocument>,
    @InjectModel(Artisan.name) private artisanModel: Model<ArtisanDocument>,
  ) {}

  async getHome() {
    const [categories, collections, featuredProducts, featuredArtisans] =
      await Promise.all([
        this.categoryModel.find().exec(),
        this.collectionModel.find().exec(),
        this.productModel
          .find()
          .populate('artisan_id')
          .populate('category_id')
          .sort({ createdAt: -1 })
          .limit(8)
          .exec(),
        this.artisanModel.find().populate('user_id').limit(6).exec(),
      ]);

    return {
      hero: {
        title: 'Crafted in Cambodia',
        subtitle:
          'Handmade gifts, souvenirs & cultural treasures — krama, silver, silk & more.',
        slides: [
          {
            id: 1,
            headline: 'Crafted in Cambodia',
            text: 'Every piece tells a story of heritage and skill.',
            image:
              'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
          },
          {
            id: 2,
            headline: 'Khmer New Year Gifts',
            text: 'Celebrate with traditional crafts and warm earth tones.',
            image:
              'https://images.unsplash.com/photo-1605647540924-852290f6e436?w=800',
          },
          {
            id: 3,
            headline: 'Meet Our Artisans',
            text: 'From Siem Reap to Phnom Penh — discover local masters.',
            image:
              'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
          },
        ],
      },
      categories,
      collections,
      featuredProducts,
      featuredArtisans,
    };
  }
}
