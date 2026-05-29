import { Body, Controller, Get, Param, Post, Req, UseGuards } from '@nestjs/common';
import { AuthUserPayload } from '../auth/auth-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ChatService } from './chat.service';

@Controller('chat')
@UseGuards(JwtAuthGuard)
export class ChatController {
  constructor(private service: ChatService) {}

  @Get('contacts')
  contacts(@Req() req: { user: AuthUserPayload }) {
    return this.service.listContacts(req.user.userId);
  }

  @Get(':otherUserId')
  conversation(
    @Req() req: { user: AuthUserPayload },
    @Param('otherUserId') otherUserId: string,
  ) {
    return this.service.getConversation(req.user.userId, otherUserId);
  }

  @Post()
  send(
    @Req() req: { user: AuthUserPayload },
    @Body() body: { receiver_id: string; message: string },
  ) {
    return this.service.send(req.user.userId, body.receiver_id, body.message);
  }
}
