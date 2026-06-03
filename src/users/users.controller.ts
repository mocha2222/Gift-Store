import { Body, Controller, Get, Param, Patch, Req, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private service: UsersService) {}

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Patch('me')
  @UseGuards(JwtAuthGuard)
  updateMe(@Req() req: any, @Body() body: Record<string, unknown>) {
    return this.service.update(req.user.userId, body);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.service.findOne(id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  update(@Param('id') id: string, @Body() body: Record<string, unknown>) {
    return this.service.update(id, body);
  }
}
