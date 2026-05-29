import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ProductMedia, ProductMediaSchema } from '../schemas/product-media.schema';
import { ProductMediaController } from './product-media.controller';
import { ProductMediaService } from './product-media.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: ProductMedia.name, schema: ProductMediaSchema },
    ]),
  ],
  controllers: [ProductMediaController],
  providers: [ProductMediaService],
})
export class ProductMediaModule {}
