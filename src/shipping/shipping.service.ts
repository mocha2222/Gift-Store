import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Order, OrderDocument } from '../schemas/order.schema';
import { Shipping, ShippingDocument } from '../schemas/shipping.schema';

@Injectable()
export class ShippingService {
  constructor(
    @InjectModel(Shipping.name) private shippingModel: Model<ShippingDocument>,
    @InjectModel(Order.name) private orderModel: Model<OrderDocument>,
  ) {}

  async findAll(userId: string) {
    const orderIds = await this.orderModel.find({ user_id: parseObjectId(userId, 'user id') }).distinct('_id');
    return this.shippingModel.find({ order_id: { $in: orderIds } }).populate('order_id').exec();
  }

  async findMy(userId: string) {
    return this.findAll(userId);
  }

  async findOne(id: string, userId: string) {
    const shipping = await this.shippingModel
      .findById(parseObjectId(id, 'shipping id'))
      .populate('order_id')
      .exec();
    if (!shipping) throw new NotFoundException('Shipping record not found');
    await this.assertOrderOwner(shipping.order_id.toString(), userId);
    return shipping;
  }

  async findByOrder(orderId: string, userId: string) {
    await this.assertOrderOwner(orderId, userId);
    return this.shippingModel
      .findOne({ order_id: parseObjectId(orderId, 'order id') })
      .populate('order_id')
      .exec();
  }

  async create(
    userId: string,
    data: {
      order_id: string;
      recipient_name: string;
      phone?: string;
      address_line1: string;
      address_line2?: string;
      city?: string;
      state?: string;
      postal_code?: string;
      country?: string;
      tracking_number?: string;
      delivery_provider?: string;
      shipping_status?: string;
      shipped_at?: string | Date;
      delivered_at?: string | Date;
    },
  ) {
    const order = await this.orderModel.findById(
      parseObjectId(data.order_id, 'order id'),
    );
    if (!order) throw new NotFoundException('Order not found');
    this.assertOwner(order.user_id.toString(), userId);

    return this.shippingModel.create({
      order_id: order._id,
      recipient_name: data.recipient_name,
      phone: data.phone,
      address_line1: data.address_line1,
      address_line2: data.address_line2,
      city: data.city,
      state: data.state,
      postal_code: data.postal_code,
      country: data.country,
      tracking_number: data.tracking_number,
      delivery_provider: data.delivery_provider,
      shipping_status: data.shipping_status,
      shipped_at: data.shipped_at ? new Date(data.shipped_at) : data.shipped_at,
      delivered_at: data.delivered_at ? new Date(data.delivered_at) : data.delivered_at,
    });
  }

  async update(
    id: string,
    userId: string,
    data: {
      recipient_name?: string;
      phone?: string;
      address_line1?: string;
      address_line2?: string;
      city?: string;
      state?: string;
      postal_code?: string;
      country?: string;
      tracking_number?: string;
      delivery_provider?: string;
      shipping_status?: string;
      shipped_at?: string | Date;
      delivered_at?: string | Date;
    },
  ) {
    const existing = await this.shippingModel.findById(parseObjectId(id, 'shipping id'));
    if (!existing) throw new NotFoundException('Shipping record not found');
    await this.assertOrderOwner(existing.order_id.toString(), userId);

    const shipping = await this.shippingModel
      .findByIdAndUpdate(
        parseObjectId(id, 'shipping id'),
        {
          ...data,
          shipped_at: data.shipped_at ? new Date(data.shipped_at) : data.shipped_at,
          delivered_at: data.delivered_at ? new Date(data.delivered_at) : data.delivered_at,
        },
        { new: true },
      )
      .populate('order_id')
      .exec();
    if (!shipping) throw new NotFoundException('Shipping record not found');
    return shipping;
  }

  async delete(id: string, userId: string) {
    const existing = await this.shippingModel.findById(parseObjectId(id, 'shipping id'));
    if (!existing) throw new NotFoundException('Shipping record not found');
    await this.assertOrderOwner(existing.order_id.toString(), userId);

    const shipping = await this.shippingModel.findByIdAndDelete(parseObjectId(id, 'shipping id'));
    if (!shipping) throw new NotFoundException('Shipping record not found');
    return { deleted: true };
  }

  private async assertOrderOwner(orderId: string, userId: string) {
    const order = await this.orderModel.findById(parseObjectId(orderId, 'order id'));
    if (!order) throw new NotFoundException('Order not found');
    if (order.user_id.toString() !== userId) {
      throw new ForbiddenException('You do not have access to this order');
    }
  }

  private assertOwner(ownerId: string, userId: string) {
    if (ownerId !== userId) {
      throw new ForbiddenException('You do not have access to this order');
    }
  }
}