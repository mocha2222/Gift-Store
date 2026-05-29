import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Collection, CollectionSchema } from '../schemas/collection.schema';
import { Product, ProductSchema } from '../schemas/product.schema';
import {
  CollectionProduct,
  CollectionProductSchema,
} from '../schemas/collection-product.schema';
import { CollectionsController } from './collections.controller';
import { CollectionsService } from './collections.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Collection.name, schema: CollectionSchema },
      { name: CollectionProduct.name, schema: CollectionProductSchema },
      { name: Product.name, schema: ProductSchema },
    ]),
  ],
  controllers: [CollectionsController],
  providers: [CollectionsService],
})
export class CollectionsModule {}
