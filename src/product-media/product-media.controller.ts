import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { MediaType } from '../common/enums';
import { ProductMediaService } from './product-media.service';

@Controller('product-media')
export class ProductMediaController {
  constructor(private service: ProductMediaService) {}

  @Get('product/:productId')
  byProduct(@Param('productId') productId: string) {
    return this.service.findByProduct(productId);
  }

  @Post()
  create(
    @Body()
    body: { product_id: string; media_type: MediaType; media_url: string },
  ) {
    return this.service.create(body);
  }
}
