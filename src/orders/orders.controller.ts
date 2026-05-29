import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AuthUserPayload } from '../auth/auth-user.decorator';
import { OrderStatus } from '../common/enums';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateOrderDto } from './dto/create-order.dto';
import { OrdersService } from './orders.service';

@Controller('orders')
export class OrdersController {
  constructor(private service: OrdersService) {}

  @Get('my')
  @UseGuards(JwtAuthGuard)
  myOrders(@Req() req: { user: AuthUserPayload }) {
    return this.service.findByUser(req.user.userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.service.findOne(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  create(
    @Req() req: { user: AuthUserPayload },
    @Body() dto: CreateOrderDto,
  ) {
    return this.service.create(req.user.userId, dto);
  }

  @Patch(':id/status')
  updateStatus(
    @Param('id') id: string,
    @Body('status') status: OrderStatus,
  ) {
    return this.service.updateStatus(id, status);
  }
}
