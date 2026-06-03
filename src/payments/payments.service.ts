import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Order, OrderDocument } from '../schemas/order.schema';
import { Payment, PaymentDocument } from '../schemas/payment.schema';

@Injectable()
export class PaymentsService {
  constructor(
    @InjectModel(Payment.name) private paymentModel: Model<PaymentDocument>,
    @InjectModel(Order.name) private orderModel: Model<OrderDocument>,
  ) {}

  async findAll(userId: string) {
    const orderIds = await this.orderModel.find({ user_id: parseObjectId(userId, 'user id') }).distinct('_id');
    return this.paymentModel.find({ order_id: { $in: orderIds } }).populate('order_id').exec();
  }

  async findMy(userId: string) {
    return this.findAll(userId);
  }

  async findOne(id: string, userId: string) {
    const payment = await this.paymentModel
      .findById(parseObjectId(id, 'payment id'))
      .populate('order_id')
      .exec();
    if (!payment) throw new NotFoundException('Payment not found');
    await this.assertOrderOwner(payment.order_id.toString(), userId);
    return payment;
  }

  async findByOrder(orderId: string, userId: string) {
    await this.assertOrderOwner(orderId, userId);
    return this.paymentModel
      .findOne({ order_id: parseObjectId(orderId, 'order id') })
      .populate('order_id')
      .exec();
  }

  async create(
    userId: string,
    data: {
      order_id: string;
      payment_method: string;
      transaction_status?: string;
      payment_reference?: string;
      amount: number;
      paid_at?: string | Date;
    },
  ) {
    const order = await this.orderModel.findById(
      parseObjectId(data.order_id, 'order id'),
    );
    if (!order) throw new NotFoundException('Order not found');
    this.assertOwner(order.user_id.toString(), userId);

    return this.paymentModel.create({
      order_id: order._id,
      payment_method: data.payment_method,
      transaction_status: data.transaction_status,
      payment_reference: data.payment_reference,
      amount: data.amount,
      paid_at: data.paid_at ? new Date(data.paid_at) : data.paid_at,
    });
  }

  async update(
    id: string,
    userId: string,
    data: {
      payment_method?: string;
      transaction_status?: string;
      payment_reference?: string;
      amount?: number;
      paid_at?: string | Date;
    },
  ) {
    const existing = await this.paymentModel.findById(parseObjectId(id, 'payment id'));
    if (!existing) throw new NotFoundException('Payment not found');
    await this.assertOrderOwner(existing.order_id.toString(), userId);

    const payment = await this.paymentModel
      .findByIdAndUpdate(
        parseObjectId(id, 'payment id'),
        {
          ...data,
          paid_at: data.paid_at ? new Date(data.paid_at) : data.paid_at,
        },
        { new: true },
      )
      .populate('order_id')
      .exec();
    if (!payment) throw new NotFoundException('Payment not found');
    return payment;
  }

  async delete(id: string, userId: string) {
    const existing = await this.paymentModel.findById(parseObjectId(id, 'payment id'));
    if (!existing) throw new NotFoundException('Payment not found');
    await this.assertOrderOwner(existing.order_id.toString(), userId);

    const payment = await this.paymentModel.findByIdAndDelete(parseObjectId(id, 'payment id'));
    if (!payment) throw new NotFoundException('Payment not found');
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