import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Artisan, ArtisanSchema } from '../schemas/artisan.schema';
import { Product, ProductSchema } from '../schemas/product.schema';
import { ArtisansController } from './artisans.controller';
import { ArtisansService } from './artisans.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Artisan.name, schema: ArtisanSchema },
      { name: Product.name, schema: ProductSchema },
    ]),
  ],
  controllers: [ArtisansController],
  providers: [ArtisansService],
})
export class ArtisansModule {}
