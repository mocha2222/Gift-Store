import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Cart, CartSchema } from '../schemas/cart.schema';
import { CartItem, CartItemSchema } from '../schemas/cart-item.schema';
import { Product, ProductSchema } from '../schemas/product.schema';
import { CartsController } from './carts.controller';
import { CartsService } from './carts.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Cart.name, schema: CartSchema },
      { name: CartItem.name, schema: CartItemSchema },
      { name: Product.name, schema: ProductSchema },
    ]),
  ],
  controllers: [CartsController],
  providers: [CartsService],
})
export class CartsModule {}