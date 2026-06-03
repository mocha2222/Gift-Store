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
    const today = new Date();
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

    const today = new Date();
    if (today < coupon.start_date || today > coupon.end_date) {
      throw new BadRequestException('Coupon expired or not yet active');
    }
    return coupon;
  }

  create(data: {
    code: string;
    discount: number;
    start_date: string | Date;
    end_date: string | Date;
  }) {
    return this.couponModel.create({
      code: data.code.toUpperCase(),
      discount: data.discount,
      start_date: data.start_date ? new Date(data.start_date) : data.start_date,
      end_date: data.end_date ? new Date(data.end_date) : data.end_date,
    });
  }
}
