import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { parseObjectId } from '../common/mongo.util';
import { Category, CategoryDocument } from '../schemas/category.schema';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectModel(Category.name) private categoryModel: Model<CategoryDocument>,
  ) {}

  findAll() {
    return this.categoryModel.find().exec();
  }

  async findOne(id: string) {
    const cat = await this.categoryModel.findById(parseObjectId(id));
    if (!cat) throw new NotFoundException('Category not found');
    return cat;
  }

  create(data: Partial<Category>) {
    return this.categoryModel.create(data);
  }
}
