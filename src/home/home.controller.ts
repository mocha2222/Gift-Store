import { Controller, Get } from '@nestjs/common';
import { HomeService } from './home.service';

@Controller('home')
export class HomeController {
  constructor(private service: HomeService) {}

  @Get()
  getHome() {
    return this.service.getHome();
  }
}
