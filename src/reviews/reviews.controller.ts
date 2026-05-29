import { Body, Controller, Get, Param, Post, Req, UseGuards } from '@nestjs/common';
import { AuthUserPayload } from '../auth/auth-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ReviewsService } from './reviews.service';

@Controller('reviews')
export class ReviewsController {
  constructor(private service: ReviewsService) {}

  @Get('product/:productId')
  byProduct(@Param('productId') productId: string) {
    return this.service.findByProduct(productId);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  create(
    @Req() req: { user: AuthUserPayload },
    @Body()
    body: {
      product_id: string;
      rating: number;
      comment?: string;
      photo?: string;
    },
  ) {
    return this.service.create(req.user.userId, body);
  }
}
