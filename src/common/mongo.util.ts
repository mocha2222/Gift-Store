import { BadRequestException } from '@nestjs/common';
import { Types } from 'mongoose';

export function parseObjectId(id: string, label = 'id'): Types.ObjectId {
  if (!Types.ObjectId.isValid(id)) {
    throw new BadRequestException(`Invalid ${label}`);
  }
  return new Types.ObjectId(id);
}
