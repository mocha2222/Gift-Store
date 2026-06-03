import { Body, Controller, Delete, Get, Param, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { AuthUserPayload } from '../auth/auth-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateShippingDto } from './dto/create-shipping.dto';
import { UpdateShippingDto } from './dto/update-shipping.dto';
import { ShippingService } from './shipping.service';

@Controller('shipping')
@UseGuards(JwtAuthGuard)
export class ShippingController {
  constructor(private service: ShippingService) {}

  @Get()
  findAll(@Req() req: { user: AuthUserPayload }) {
    return this.service.findAll(req.user.userId);
  }

  @Get('my')
  findMy(@Req() req: { user: AuthUserPayload }) {
    return this.service.findMy(req.user.userId);
  }

  @Get('order/:orderId')
  findByOrder(@Param('orderId') orderId: string, @Req() req: { user: AuthUserPayload }) {
    return this.service.findByOrder(orderId, req.user.userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @Req() req: { user: AuthUserPayload }) {
    return this.service.findOne(id, req.user.userId);
  }

  @Post()
  create(
    @Req() req: { user: AuthUserPayload },
    @Body()
    body: CreateShippingDto,
  ) {
    return this.service.create(req.user.userId, body);
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @Req() req: { user: AuthUserPayload },
    @Body()
    body: UpdateShippingDto,
  ) {
    return this.service.update(id, req.user.userId, body);
  }

  @Delete(':id')
  delete(@Param('id') id: string, @Req() req: { user: AuthUserPayload }) {
    return this.service.delete(id, req.user.userId);
  }
}