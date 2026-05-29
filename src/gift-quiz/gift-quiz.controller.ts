import { Body, Controller, Get, Post } from '@nestjs/common';
import { GiftQuizService } from './gift-quiz.service';

@Controller('gift-quiz')
export class GiftQuizController {
  constructor(private service: GiftQuizService) {}

  @Get('questions')
  questions() {
    return this.service.getQuestions();
  }

  @Post('recommend')
  recommend(
    @Body()
    body: {
      recipient?: string;
      occasion?: string;
      budget?: string;
      style?: string;
    },
  ) {
    return this.service.submitAnswers(body);
  }
}
