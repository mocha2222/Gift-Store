import { Module } from '@nestjs/common';
import { ProductsModule } from '../products/products.module';
import { GiftQuizController } from './gift-quiz.controller';
import { GiftQuizService } from './gift-quiz.service';

@Module({
  imports: [ProductsModule],
  controllers: [GiftQuizController],
  providers: [GiftQuizService],
})
export class GiftQuizModule {}
