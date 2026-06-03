import mongoose from 'mongoose';
import * as bcrypt from 'bcrypt';

async function run() {
  await mongoose.connect('mongodb://127.0.0.1:27017/gift_souvenir');
  
  // Check if admin already exists
  const existing = await mongoose.connection.collection('users').findOne({ email: 'admin@test.com' });
  if (existing) {
    console.log('Admin user already exists');
    process.exit(0);
  }

  const password = await bcrypt.hash('password123', 10);
  
  await mongoose.connection.collection('users').insertOne({
    name: 'Admin',
    email: 'admin@test.com',
    password: password,
    role: 'admin',
    __v: 0,
    createdAt: new Date(),
    updatedAt: new Date()
  });
  console.log('Admin user created successfully');
  process.exit(0);
}

run().catch(console.error);
