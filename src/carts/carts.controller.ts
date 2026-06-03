import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AuthUserPayload } from '../auth/auth-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AddCartItemDto } from './dto/add-cart-item.dto';
import { UpdateCartItemDto } from './dto/update-cart-item.dto';
import { CartsService } from './carts.service';

@Controller('carts')
@UseGuards(JwtAuthGuard)
export class CartsController {
  constructor(private service: CartsService) {}

  @Get()
  findAll(@Req() req: { user: AuthUserPayload }) {
    return this.service.findAll(req.user.userId);
  }

  @Get('my')
  findMy(@Req() req: { user: AuthUserPayload }) {
    return this.service.findByUser(req.user.userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @Req() req: { user: AuthUserPayload }) {
    return this.service.findOne(id, req.user.userId);
  }

  @Post()
  create(@Req() req: { user: AuthUserPayload }) {
    return this.service.create(req.user.userId);
  }

  @Post(':cartId/items')
  addItem(
    @Param('cartId') cartId: string,
    @Req() req: { user: AuthUserPayload },
    @Body() body: AddCartItemDto,
  ) {
    return this.service.addItem(cartId, req.user.userId, body);
  }

  @Patch(':cartId/items/:productId')
  updateItem(
    @Param('cartId') cartId: string,
    @Param('productId') productId: string,
    @Req() req: { user: AuthUserPayload },
    @Body() body: UpdateCartItemDto,
  ) {
    return this.service.updateItem(cartId, productId, req.user.userId, body.quantity);
  }

  @Delete(':cartId/items/:productId')
  removeItem(
    @Param('cartId') cartId: string,
    @Param('productId') productId: string,
    @Req() req: { user: AuthUserPayload },
  ) {
    return this.service.removeItem(cartId, productId, req.user.userId);
  }

  @Delete(':id/clear')
  clear(@Param('id') id: string, @Req() req: { user: AuthUserPayload }) {
    return this.service.clear(id, req.user.userId);
  }

  @Delete(':id')
  delete(@Param('id') id: string, @Req() req: { user: AuthUserPayload }) {
    return this.service.delete(id, req.user.userId);
  }
}