import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Artisan, ArtisanDocument } from '../schemas/artisan.schema';
import { Product, ProductDocument } from '../schemas/product.schema';

@Injectable()
export class ArtisansService {
  constructor(
    @InjectModel(Artisan.name) private artisanModel: Model<ArtisanDocument>,
    @InjectModel(Product.name) private productModel: Model<ProductDocument>,
  ) {}

  findAll() {
    return this.artisanModel.find().populate('user_id').exec();
  }

  findFeatured() {
    return this.artisanModel.find().populate('user_id').limit(6).exec();
  }

  async findOne(id: string): Promise<Record<string, unknown>> {
    const artisan = await this.artisanModel
      .findById(parseObjectId(id, 'artisan id'))
      .populate('user_id')
      .exec();
    if (!artisan) throw new NotFoundException('Artisan not found');

    const products = await this.productModel
      .find({ artisan_id: artisan._id })
      .populate('category_id')
      .exec();

    return { ...artisan.toJSON(), products };
  }

  async findNearby(
    lat: number,
    lng: number,
    radiusKm = 50,
  ): Promise<Record<string, unknown>[]> {
    const shops = await this.artisanModel.find().populate('user_id').exec();
    return shops
      .filter((a) => a.latitude != null && a.longitude != null)
      .map((a) => ({
        ...a.toJSON(),
        distance_km: this.haversineKm(
          lat,
          lng,
          a.latitude!,
          a.longitude!,
        ),
      }))
      .filter((a) => a.distance_km <= radiusKm)
      .sort((a, b) => a.distance_km - b.distance_km);
  }

  private haversineKm(
    lat1: number,
    lng1: number,
    lat2: number,
    lng2: number,
  ): number {
    const R = 6371;
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLng = ((lng2 - lng1) * Math.PI) / 180;
    const a =
      Math.sin(dLat / 2) ** 2 +
      Math.cos((lat1 * Math.PI) / 180) *
        Math.cos((lat2 * Math.PI) / 180) *
        Math.sin(dLng / 2) ** 2;
    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  }

  findMapLocations() {
    return this.artisanModel
      .find()
      .select('shop_name shop_location region craft_type latitude longitude cover_image')
      .exec();
  }

  create(data: Partial<Artisan>) {
    return this.artisanModel.create(data);
  }
}
