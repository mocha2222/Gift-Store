import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Artisan, ArtisanSchema } from '../schemas/artisan.schema';
import { Category, CategorySchema } from '../schemas/category.schema';
import { Collection, CollectionSchema } from '../schemas/collection.schema';
import {
  CollectionProduct,
  CollectionProductSchema,
} from '../schemas/collection-product.schema';
import { Coupon, CouponSchema } from '../schemas/coupon.schema';
import { Product, ProductSchema } from '../schemas/product.schema';
import { ProductMedia, ProductMediaSchema } from '../schemas/product-media.schema';
import { User, UserSchema } from '../schemas/user.schema';
import { SeedService } from './seed.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Artisan.name, schema: ArtisanSchema },
      { name: Category.name, schema: CategorySchema },
      { name: Product.name, schema: ProductSchema },
      { name: Collection.name, schema: CollectionSchema },
      { name: CollectionProduct.name, schema: CollectionProductSchema },
      { name: Coupon.name, schema: CouponSchema },
      { name: ProductMedia.name, schema: ProductMediaSchema },
    ]),
  ],
  providers: [SeedService],
})
export class SeedModule {}
