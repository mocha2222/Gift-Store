import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Order, OrderSchema } from '../schemas/order.schema';
import { Shipping, ShippingSchema } from '../schemas/shipping.schema';
import { ShippingController } from './shipping.controller';
import { ShippingService } from './shipping.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Shipping.name, schema: ShippingSchema },
      { name: Order.name, schema: OrderSchema },
    ]),
  ],
  controllers: [ShippingController],
  providers: [ShippingService],
})
export class ShippingModule {}