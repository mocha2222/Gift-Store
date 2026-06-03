import { Body, Controller, Delete, Get, Param, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { AuthUserPayload } from '../auth/auth-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreatePaymentDto } from './dto/create-payment.dto';
import { UpdatePaymentDto } from './dto/update-payment.dto';
import { PaymentsService } from './payments.service';

@Controller('payments')
@UseGuards(JwtAuthGuard)
export class PaymentsController {
  constructor(private service: PaymentsService) {}

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
    body: CreatePaymentDto,
  ) {
    return this.service.create(req.user.userId, body);
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @Req() req: { user: AuthUserPayload },
    @Body()
    body: UpdatePaymentDto,
  ) {
    return this.service.update(id, req.user.userId, body);
  }

  @Delete(':id')
  delete(@Param('id') id: string, @Req() req: { user: AuthUserPayload }) {
    return this.service.delete(id, req.user.userId);
  }
}