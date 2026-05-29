import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { CollectionsService } from './collections.service';

@Controller('collections')
export class CollectionsController {
  constructor(private service: CollectionsService) {}

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.service.findOne(id);
  }

  @Post()
  create(@Body() body: { title: string; description?: string; cover_image?: string }) {
    return this.service.create(body);
  }

  @Post(':id/products/:productId')
  addProduct(
    @Param('id') id: string,
    @Param('productId') productId: string,
  ) {
    return this.service.addProduct(id, productId);
  }
}
