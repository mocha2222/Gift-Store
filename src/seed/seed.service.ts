import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import * as bcrypt from 'bcrypt';
import { Model } from 'mongoose';
import { MediaType, UserRole } from '../common/enums';
import { Artisan, ArtisanDocument } from '../schemas/artisan.schema';
import { Category, CategoryDocument } from '../schemas/category.schema';
import { Collection, CollectionDocument } from '../schemas/collection.schema';
import {
  CollectionProduct,
  CollectionProductDocument,
} from '../schemas/collection-product.schema';
import { Coupon, CouponDocument } from '../schemas/coupon.schema';
import { Product, ProductDocument } from '../schemas/product.schema';
import { ProductMedia, ProductMediaDocument } from '../schemas/product-media.schema';
import { User, UserDocument } from '../schemas/user.schema';

@Injectable()
export class SeedService implements OnModuleInit {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    @InjectModel(Artisan.name) private artisanModel: Model<ArtisanDocument>,
    @InjectModel(Category.name) private categoryModel: Model<CategoryDocument>,
    @InjectModel(Product.name) private productModel: Model<ProductDocument>,
    @InjectModel(Collection.name)
    private collectionModel: Model<CollectionDocument>,
    @InjectModel(CollectionProduct.name)
    private collectionProductModel: Model<CollectionProductDocument>,
    @InjectModel(Coupon.name) private couponModel: Model<CouponDocument>,
    @InjectModel(ProductMedia.name)
    private mediaModel: Model<ProductMediaDocument>,
  ) {}

  async onModuleInit() {
    const count = await this.userModel.countDocuments();
    if (count > 0) return;
    await this.seed();
    console.log('MongoDB seeded with sample Cambodia gift data');
  }

  private async seed() {
    const password = await bcrypt.hash('password123', 10);

    await this.userModel.create({
      name: 'Admin',
      email: 'admin@test.com',
      password,
      role: UserRole.ADMIN,
    });

    await this.userModel.create({
      name: 'Sokha Chan',
      email: 'customer@test.com',
      password,
      phone: '+855 12 345 678',
      role: UserRole.CUSTOMER,
      address: 'Phnom Penh',
    });

    const artisanUser1 = await this.userModel.create({
      name: 'Bopha Meas',
      email: 'artisan1@test.com',
      password,
      role: UserRole.ARTISAN,
      profile_image: 'https://i.pravatar.cc/150?u=bopha',
    });

    const artisanUser2 = await this.userModel.create({
      name: 'Vannak Lim',
      email: 'artisan2@test.com',
      password,
      role: UserRole.ARTISAN,
      profile_image: 'https://i.pravatar.cc/150?u=vannak',
    });

    const artisan1 = await this.artisanModel.create({
      user_id: artisanUser1._id,
      shop_name: 'Silk Road Atelier',
      region: 'Siem Reap',
      craft_type: 'Silk weaving',
      story: 'Third-generation weaver preserving Khmer silk patterns.',
      shop_location: 'Old Market Area, Siem Reap',
      latitude: 13.3633,
      longitude: 103.8564,
      cover_image:
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=600',
    });

    const artisan2 = await this.artisanModel.create({
      user_id: artisanUser2._id,
      shop_name: 'Silver Lotus Workshop',
      region: 'Phnom Penh',
      craft_type: 'Silverware',
      story: 'Handcrafted Khmer silver inspired by Angkor motifs.',
      shop_location: 'Russian Market, Phnom Penh',
      latitude: 11.5564,
      longitude: 104.9282,
      cover_image:
        'https://images.unsplash.com/photo-1605647540924-852290f6e436?w=600',
    });

    const categories = await this.categoryModel.insertMany([
      { category_name: 'Textile', image: 'textile' },
      { category_name: 'Silver', image: 'silver' },
      { category_name: 'Wood', image: 'wood' },
      { category_name: 'Edible', image: 'edible' },
      { category_name: 'Jewelry', image: 'jewelry' },
    ]);

    const products = await this.productModel.insertMany([
      {
        artisan_id: artisan1._id,
        category_id: categories[0]._id,
        name: 'Traditional Krama Scarf',
        description: 'Hand-woven cotton krama in red & white check.',
        price: 18.5,
        stock: 50,
        material: 'Cotton',
        dimensions: '180cm x 40cm',
        story: 'Worn daily and gifted at Khmer New Year.',
        image:
          'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=400',
        gift_for: 'him',
        occasion: 'new_year',
      },
      {
        artisan_id: artisan1._id,
        category_id: categories[0]._id,
        name: 'Golden Silk Shawl',
        description: 'Festive silk shawl with gold thread accents.',
        price: 89,
        stock: 15,
        material: 'Silk, gold thread',
        dimensions: '200cm x 80cm',
        story: 'Woven for weddings and ceremonies.',
        image:
          'https://images.unsplash.com/photo-1583292652852-a134c581d093?w=400',
        gift_for: 'her',
        occasion: 'wedding',
      },
      {
        artisan_id: artisan2._id,
        category_id: categories[1]._id,
        name: 'Angkor Lotus Silver Bowl',
        description: 'Engraved sterling silver bowl with lotus motif.',
        price: 120,
        stock: 8,
        material: 'Sterling silver',
        dimensions: '12cm diameter x 6cm height',
        story: 'Inspired by bas-reliefs at Angkor Wat.',
        image:
          'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=400',
        gift_for: 'couple',
        occasion: 'wedding',
      },
      {
        artisan_id: artisan2._id,
        category_id: categories[4]._id,
        name: 'Silver Apsara Pendant',
        description: 'Delicate apsara dancer pendant on chain.',
        price: 65,
        stock: 20,
        material: 'Silver',
        dimensions: '3cm x 2cm pendant',
        story: 'A timeless souvenir from Cambodia.',
        image:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400',
        gift_for: 'her',
        occasion: 'tourist',
      },
      {
        artisan_id: artisan1._id,
        category_id: categories[2]._id,
        name: 'Teak Elephant Carving',
        description: 'Hand-carved teak elephant with Khmer patterns.',
        price: 45,
        stock: 25,
        material: 'Teak wood',
        dimensions: '15cm tall x 12cm wide',
        story: 'Symbol of good luck and strength.',
        image:
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
        gift_for: 'family',
        occasion: 'tourist',
      },
      {
        artisan_id: artisan1._id,
        category_id: categories[3]._id,
        name: 'Palm Sugar Gift Box',
        description: 'Organic palm sugar from Kampong Speu.',
        price: 22,
        stock: 40,
        material: 'Palm sugar',
        dimensions: '20cm x 15cm x 8cm box',
        story: 'Sweet gift for Pchum Ben and festivals.',
        image:
          'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400',
        gift_for: 'family',
        occasion: 'new_year',
      },
    ]);

    await this.mediaModel.insertMany([
      {
        product_id: products[0]._id,
        media_type: MediaType.VIDEO,
        media_url:
          'https://sample-videos.com/video321/mp4/240/big_buck_bunny_240p_1mb.mp4',
      },
      {
        product_id: products[2]._id,
        media_type: MediaType.IMAGE,
        media_url:
          'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=800',
      },
    ]);

    // Create collections (without embedded product_ids). We'll create join records below.
    const collectionsData = [
      {
        title: 'For Him',
        description: 'Thoughtful gifts for men — krama, wood, silver.',
        cover_image:
          'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=400',
      },
      {
        title: 'For Her',
        description: 'Silk, jewelry & elegant Cambodian crafts.',
        cover_image:
          'https://images.unsplash.com/photo-1583292652852-a134c581d093?w=400',
      },
      {
        title: 'Wedding',
        description: 'Ceremonial silver and silk for special days.',
        cover_image:
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
      },
      {
        title: 'Tourist Favorites',
        description: 'Best souvenirs from Cambodia.',
        cover_image:
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
      },
      {
        title: 'Songkran Gift Set',
        description: 'Festive set for water festival season.',
        cover_image:
          'https://images.unsplash.com/photo-1605647540924-852290f6e436?w=400',
      },
    ];

    const createdCollections = await this.collectionModel.insertMany(collectionsData);

    // Mapping of which product indexes belong to each collection (based on original seed)
    const collectionProductIndexMap: number[][] = [
      [0, 4],
      [1, 3],
      [1, 2],
      [3, 4],
      [0, 5],
    ];

    // Create join documents in collection_products
    const cpDocs: { collection_id: any; product_id: any }[] = [];
    createdCollections.forEach((col, i) => {
      const indexes = collectionProductIndexMap[i] || [];
      indexes.forEach((pi) => {
        cpDocs.push({ collection_id: col._id, product_id: products[pi]._id });
      });
    });

    if (cpDocs.length > 0) {
      await this.collectionProductModel.insertMany(cpDocs);
    }

    const year = new Date().getFullYear();
    await this.couponModel.insertMany([
      {
        code: 'KHMERNEWYEAR',
        discount: 15,
        start_date: `${year}-04-01`,
        end_date: `${year}-04-30`,
      },
      {
        code: 'PCHUMBEN',
        discount: 10,
        start_date: `${year}-09-01`,
        end_date: `${year}-10-15`,
      },
      {
        code: 'WELCOME10',
        discount: 10,
        start_date: `${year}-01-01`,
        end_date: `${year}-12-31`,
      },
    ]);
  }
}
