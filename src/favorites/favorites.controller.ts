import {
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AuthUserPayload } from '../auth/auth-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { FavoritesService } from './favorites.service';

@Controller('favorites')
@UseGuards(JwtAuthGuard)
export class FavoritesController {
  constructor(private service: FavoritesService) {}

  @Get()
  mine(@Req() req: { user: AuthUserPayload }) {
    return this.service.findByUser(req.user.userId);
  }

  @Post(':productId')
  add(
    @Req() req: { user: AuthUserPayload },
    @Param('productId') productId: string,
  ) {
    return this.service.add(req.user.userId, productId);
  }

  @Delete(':productId')
  remove(
    @Req() req: { user: AuthUserPayload },
    @Param('productId') productId: string,
  ) {
    return this.service.remove(req.user.userId, productId);
  }
}
