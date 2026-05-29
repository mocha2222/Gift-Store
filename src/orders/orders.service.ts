import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { OrderStatus } from '../common/enums';
import { parseObjectId } from '../common/mongo.util';
import { Coupon, CouponDocument } from '../schemas/coupon.schema';
import { Order, OrderDocument } from '../schemas/order.schema';
import { Product, ProductDocument } from '../schemas/product.schema';
import { CreateOrderDto } from './dto/create-order.dto';

@Injectable()
export class OrdersService {
  constructor(
    @InjectModel(Order.name) private orderModel: Model<OrderDocument>,
    @InjectModel(Product.name) private productModel: Model<ProductDocument>,
    @InjectModel(Coupon.name) private couponModel: Model<CouponDocument>,
  ) {}

  findByUser(userId: string) {
    return this.orderModel
      .find({ user_id: parseObjectId(userId) })
      .populate({ path: 'items.product_id' })
      .sort({ createdAt: -1 })
      .exec();
  }

  async findOne(id: string) {
    const order = await this.orderModel
      .findById(parseObjectId(id, 'order id'))
      .populate('user_id')
      .populate({ path: 'items.product_id' })
      .exec();
    if (!order) throw new NotFoundException('Order not found');
    return order;
  }

  async create(userId: string, dto: CreateOrderDto) {
    if (!dto.items?.length) {
      throw new BadRequestException('Order must have at least one item');
    }

    let total = 0;
    const lineItems: { product_id: string; quantity: number; subtotal: number }[] = [];

    for (const item of dto.items) {
      const product = await this.productModel.findById(
        parseObjectId(item.product_id, 'product id'),
      );
      if (!product) {
        throw new NotFoundException(`Product ${item.product_id} not found`);
      }
      if (product.stock < item.quantity) {
        throw new BadRequestException(`Insufficient stock for ${product.name}`);
      }

      const subtotal = product.price * item.quantity;
      total += subtotal;
      lineItems.push({
        product_id: product._id.toString(),
        quantity: item.quantity,
        subtotal,
      });

      product.stock -= item.quantity;
      await product.save();
    }

    if (dto.coupon_code) {
      const coupon = await this.applyCoupon(dto.coupon_code);
      total = total * (1 - coupon.discount / 100);
    }

    const order = await this.orderModel.create({
      user_id: parseObjectId(userId),
      items: lineItems.map((i) => ({
        product_id: parseObjectId(i.product_id),
        quantity: i.quantity,
        subtotal: i.subtotal,
      })),
      total_price: Math.round(total * 100) / 100,
      delivery_date: dto.delivery_date,
      gift_wrap: dto.gift_wrap ?? false,
      personal_message: dto.personal_message,
      coupon_code: dto.coupon_code,
      status: OrderStatus.PENDING,
    });

    return this.findOne(order._id.toString());
  }

  private async applyCoupon(code: string) {
    const coupon = await this.couponModel.findOne({
      code: code.toUpperCase(),
    });
    if (!coupon) throw new BadRequestException('Invalid coupon code');

    const today = new Date().toISOString().slice(0, 10);
    if (today < coupon.start_date || today > coupon.end_date) {
      throw new BadRequestException('Coupon is not valid for this date');
    }
    return coupon;
  }

  async updateStatus(id: string, status: OrderStatus) {
    const order = await this.orderModel
      .findByIdAndUpdate(parseObjectId(id, 'order id'), { status }, { new: true })
      .exec();
    if (!order) throw new NotFoundException('Order not found');
    return this.findOne(id);
  }
}
