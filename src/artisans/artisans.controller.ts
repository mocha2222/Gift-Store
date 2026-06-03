import {
  Body,
  Controller,
  Get,
  Param,
  ParseEnumPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { ArtisanStatus } from '../common/enums';
import { ArtisansService } from './artisans.service';

@Controller('artisans')
export class ArtisansController {
  constructor(private service: ArtisansService) {}

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Get('featured')
  featured() {
    return this.service.findFeatured();
  }

  @Get('map')
  map() {
    return this.service.findMapLocations();
  }

  @Get('nearby')
  nearby(
    @Query('lat') lat: string,
    @Query('lng') lng: string,
    @Query('radius') radius?: string,
  ): Promise<Record<string, unknown>[]> {
    return this.service.findNearby(+lat, +lng, radius ? +radius : 50);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.service.findOne(id);
  }

  @Post()
  create(@Body() body: Record<string, unknown>) {
    return this.service.create(body);
  }

  @Patch(':id/status')
  updateStatus(
    @Param('id') id: string,
    @Body('status', new ParseEnumPipe(ArtisanStatus)) status: ArtisanStatus,
  ) {
    return this.service.updateStatus(id, status);
  }
}
