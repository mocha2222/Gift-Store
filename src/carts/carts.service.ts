import {
  BadRequestException,
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Cart, CartDocument } from '../schemas/cart.schema';
import { CartItem, CartItemDocument } from '../schemas/cart-item.schema';
import { Product, ProductDocument } from '../schemas/product.schema';

@Injectable()
export class CartsService {
  constructor(
    @InjectModel(Cart.name) private cartModel: Model<CartDocument>,
    @InjectModel(CartItem.name) private cartItemModel: Model<CartItemDocument>,
    @InjectModel(Product.name) private productModel: Model<ProductDocument>,
  ) {}

  findAll(userId: string) {
    return this.findByUser(userId);
  }

  async findOne(id: string, userId: string) {
    const cart = await this.cartModel
      .findById(parseObjectId(id, 'cart id'))
      .populate('user_id')
      .exec();
    if (!cart) throw new NotFoundException('Cart not found');
    this.assertOwner(cart.user_id.toString(), userId);
    return this.withItems(cart);
  }

  async findByUser(userId: string) {
    const cart = await this.cartModel
      .findOne({ user_id: parseObjectId(userId, 'user id') })
      .populate('user_id')
      .exec();
    if (!cart) throw new NotFoundException('Cart not found');
    return this.withItems(cart);
  }

  async create(userId: string) {
    const existing = await this.cartModel.findOne({
      user_id: parseObjectId(userId, 'user id'),
    });
    if (existing) return this.findOne(existing._id.toString(), userId);

    const cart = await this.cartModel.create({
      user_id: parseObjectId(userId, 'user id'),
    });
    return this.findOne(cart._id.toString(), userId);
  }

  async addItem(
    cartId: string,
    userId: string,
    data: { product_id: string; quantity: number },
  ) {
    if (data.quantity < 1) {
      throw new BadRequestException('Quantity must be at least 1');
    }

    const cart = await this.cartModel.findById(parseObjectId(cartId, 'cart id'));
    if (!cart) throw new NotFoundException('Cart not found');
    this.assertOwner(cart.user_id.toString(), userId);

    const product = await this.productModel.findById(
      parseObjectId(data.product_id, 'product id'),
    );
    if (!product) throw new NotFoundException('Product not found');

    const price = product.price;
    const subtotal = price * data.quantity;

    const item = await this.cartItemModel.findOneAndUpdate(
      {
        cart_id: cart._id,
        product_id: product._id,
      },
      {
        cart_id: cart._id,
        product_id: product._id,
        quantity: data.quantity,
        price,
        subtotal,
      },
      { upsert: true, new: true, setDefaultsOnInsert: true },
    );

    return item;
  }

  async updateItem(
    cartId: string,
    productId: string,
    userId: string,
    quantity: number,
  ) {
    if (quantity < 1) {
      throw new BadRequestException('Quantity must be at least 1');
    }

    const cart = await this.cartModel.findById(parseObjectId(cartId, 'cart id'));
    if (!cart) throw new NotFoundException('Cart not found');
    this.assertOwner(cart.user_id.toString(), userId);

    const item = await this.cartItemModel.findOne({
      cart_id: parseObjectId(cartId, 'cart id'),
      product_id: parseObjectId(productId, 'product id'),
    });
    if (!item) throw new NotFoundException('Cart item not found');

    item.quantity = quantity;
    item.subtotal = item.price * quantity;
    await item.save();
    return item;
  }

  async removeItem(cartId: string, productId: string, userId: string) {
    const cart = await this.cartModel.findById(parseObjectId(cartId, 'cart id'));
    if (!cart) throw new NotFoundException('Cart not found');
    this.assertOwner(cart.user_id.toString(), userId);

    const result = await this.cartItemModel.findOneAndDelete({
      cart_id: parseObjectId(cartId, 'cart id'),
      product_id: parseObjectId(productId, 'product id'),
    });
    if (!result) throw new NotFoundException('Cart item not found');
    return { removed: true };
  }

  async clear(cartId: string, userId: string) {
    const cart = await this.cartModel.findById(parseObjectId(cartId, 'cart id'));
    if (!cart) throw new NotFoundException('Cart not found');
    this.assertOwner(cart.user_id.toString(), userId);

    await this.cartItemModel.deleteMany({
      cart_id: parseObjectId(cartId, 'cart id'),
    });
    return { cleared: true };
  }

  async delete(id: string, userId: string) {
    const cart = await this.cartModel.findByIdAndDelete(
      parseObjectId(id, 'cart id'),
    );
    if (!cart) throw new NotFoundException('Cart not found');
    this.assertOwner(cart.user_id.toString(), userId);
    await this.cartItemModel.deleteMany({ cart_id: cart._id });
    return { deleted: true };
  }

  private async withItems(cart: CartDocument) {
    const items = await this.cartItemModel
      .find({ cart_id: cart._id })
      .populate('product_id')
      .exec();
    return { ...cart.toJSON(), items };
  }

  private assertOwner(ownerId: string, userId: string) {
    if (ownerId !== userId) {
      throw new ForbiddenException('You do not have access to this cart');
    }
  }
}