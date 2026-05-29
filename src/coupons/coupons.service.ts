import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Coupon, CouponDocument } from '../schemas/coupon.schema';

@Injectable()
export class CouponsService {
  constructor(
    @InjectModel(Coupon.name) private couponModel: Model<CouponDocument>,
  ) {}

  findActive() {
    const today = new Date().toISOString().slice(0, 10);
    return this.couponModel
      .find({ start_date: { $lte: today }, end_date: { $gte: today } })
      .exec();
  }

  findAll() {
    return this.couponModel.find().exec();
  }

  async validate(code: string) {
    const coupon = await this.couponModel.findOne({
      code: code.toUpperCase(),
    });
    if (!coupon) throw new BadRequestException('Invalid coupon');

    const today = new Date().toISOString().slice(0, 10);
    if (today < coupon.start_date || today > coupon.end_date) {
      throw new BadRequestException('Coupon expired or not yet active');
    }
    return coupon;
  }

  create(data: Partial<Coupon>) {
    return this.couponModel.create({
      ...data,
      code: data.code?.toUpperCase(),
    });
  }
}
