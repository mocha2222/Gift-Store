import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { getModelToken } from '@nestjs/mongoose';
import * as bcrypt from 'bcrypt';
import { Model } from 'mongoose';
import { User, UserDocument } from './schemas/user.schema';
import { UserRole } from './common/enums';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    bodyParser: true,
  });
  app.enableCors();
  app.useGlobalPipes(
    new ValidationPipe({ whitelist: true, transform: true }),
  );
  app.setGlobalPrefix('api');

  // Increase JSON body size limit to 5MB for profile images
  const expressApp = app.getHttpAdapter().getInstance();
  const bodyParser = require('body-parser');
  expressApp.use(bodyParser.json({ limit: '5mb' }));
  expressApp.use(bodyParser.urlencoded({ limit: '5mb', extended: true }));
  // Seed a fixed admin account if missing
  try {
    const userModel = app.get<Model<UserDocument>>(getModelToken(User.name));
    const adminEmail = process.env.ADMIN_EMAIL ?? 'admin@gmail.com';
    const adminPass = process.env.ADMIN_PASSWORD ?? 'admin123';
    const existing = await userModel.findOne({ email: adminEmail }).exec();
    if (!existing) {
      const hash = await bcrypt.hash(adminPass, 10);
      await userModel.create({ name: 'Admin', email: adminEmail, password: hash, role: UserRole.ADMIN });
      console.log(`Seeded admin user: ${adminEmail}`);
    }
  } catch (err) {
    console.warn('Could not seed admin user', err);
  }
  const port = process.env.PORT ?? 3000;
  await app.listen(port);
  console.log(`API running at http://localhost:${port}/api`);
}
bootstrap();
