import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import * as bcrypt from 'bcrypt';
import { Model } from 'mongoose';
import { ArtisanStatus, UserRole } from '../common/enums';
import { Artisan, ArtisanDocument } from '../schemas/artisan.schema';
import { User, UserDocument } from '../schemas/user.schema';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    @InjectModel(Artisan.name) private artisanModel: Model<ArtisanDocument>,
    private jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    const exists = await this.userModel.findOne({ email: dto.email });
    if (exists) throw new ConflictException('Email already registered');

    const hash = await bcrypt.hash(dto.password, 10);
    const user = await this.userModel.create({
      ...dto,
      password: hash,
      role: dto.role ?? UserRole.CUSTOMER,
    });

    if (user.role === UserRole.ARTISAN) {
      await this.artisanModel.create({
        user_id: user._id,
        shop_name: user.name,
        status: ArtisanStatus.PENDING_SETUP,
      });
    }

    return this.tokenResponse(user);
  }

  async login(dto: LoginDto) {
    const user = await this.userModel
      .findOne({ email: dto.email })
      .select('+password');
    if (!user || !(await bcrypt.compare(dto.password, user.password))) {
      throw new UnauthorizedException('Invalid email or password');
    }
    return this.tokenResponse(user);
  }

  private tokenResponse(user: UserDocument) {
    const safe = user.toJSON();
    const token = this.jwtService.sign({
      sub: user._id.toString(),
      email: user.email,
      role: user.role,
    });
    return { user: safe, access_token: token };
  }
}
