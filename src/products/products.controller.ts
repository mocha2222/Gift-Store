import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { ProductsService } from './products.service';

@Controller('products')
export class ProductsController {
  constructor(private service: ProductsService) {}

  @Get()
  findAll(
    @Query('category_id') categoryId?: string,
    @Query('artisan_id') artisanId?: string,
  ) {
    return this.service.findAll({
      category_id: categoryId,
      artisan_id: artisanId,
    });
  }

  @Get('featured')
  featured() {
    return this.service.findFeatured();
  }

  @Get(':id')
  findOne(@Param('id') id: string): Promise<Record<string, unknown>> {
    return this.service.findOne(id);
  }

  @Post()
  create(@Body() body: Record<string, unknown>) {
    return this.service.create(body);
  }
}
