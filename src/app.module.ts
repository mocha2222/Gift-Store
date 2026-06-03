import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { ArtisansModule } from './artisans/artisans.module';
import { AuthModule } from './auth/auth.module';
import { CategoriesModule } from './categories/categories.module';
import { ChatModule } from './chat/chat.module';
import { CollectionsModule } from './collections/collections.module';
import { CouponsModule } from './coupons/coupons.module';
import { FavoritesModule } from './favorites/favorites.module';
import { GiftQuizModule } from './gift-quiz/gift-quiz.module';
import { CartsModule } from './carts/carts.module';
import { OrdersModule } from './orders/orders.module';
import { PaymentsModule } from './payments/payments.module';
import { ProductMediaModule } from './product-media/product-media.module';
import { ProductsModule } from './products/products.module';
import { ReviewsModule } from './reviews/reviews.module';
import { ShippingModule } from './shipping/shipping.module';
import { SeedModule } from './seed/seed.module';
import { UsersModule } from './users/users.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        uri: config.get<string>('MONGODB_URI') ?? 'mongodb://127.0.0.1:27017/gift_souvenir',
      }),
    }),
    SeedModule,
    AuthModule,
    UsersModule,
    ArtisansModule,
    CategoriesModule,
    ProductsModule,
    CartsModule,
    CollectionsModule,
    FavoritesModule,
    OrdersModule,
    ReviewsModule,
    ChatModule,
    CouponsModule,
    PaymentsModule,
    ShippingModule,
    ProductMediaModule,
    GiftQuizModule,
  ],
})
export class AppModule {}
