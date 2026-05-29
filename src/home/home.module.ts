import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Artisan, ArtisanSchema } from '../schemas/artisan.schema';
import { Category, CategorySchema } from '../schemas/category.schema';
import { Collection, CollectionSchema } from '../schemas/collection.schema';
import { Product, ProductSchema } from '../schemas/product.schema';
import { HomeController } from './home.controller';
import { HomeService } from './home.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Category.name, schema: CategorySchema },
      { name: Collection.name, schema: CollectionSchema },
      { name: Product.name, schema: ProductSchema },
      { name: Artisan.name, schema: ArtisanSchema },
    ]),
  ],
  controllers: [HomeController],
  providers: [HomeService],
})
export class HomeModule {}
