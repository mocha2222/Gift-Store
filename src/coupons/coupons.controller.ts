import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { CouponsService } from './coupons.service';

@Controller('coupons')
export class CouponsController {
  constructor(private service: CouponsService) {}

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Get('active')
  active() {
    return this.service.findActive();
  }

  @Get('validate/:code')
  validate(@Param('code') code: string) {
    return this.service.validate(code);
  }

  @Post()
  create(
    @Body()
    body: { code: string; discount: number; start_date: string; end_date: string },
  ) {
    return this.service.create(body);
  }
}
