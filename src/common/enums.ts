export enum UserRole {
  CUSTOMER = 'customer',
  ARTISAN = 'artisan',
  ADMIN = 'admin',
}

export enum ArtisanStatus {
  PENDING_SETUP = 'pending_setup',
  ACTIVE = 'active',
  SUSPENDED = 'suspended',
}

export enum OrderStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  SHIPPED = 'shipped',
  DELIVERED = 'delivered',
  CANCELLED = 'cancelled',
}

export enum MediaType {
  IMAGE = 'image',
  VIDEO = 'video',
}

export enum PaymentStatus {
  PENDING = 'pending',
  PAID = 'paid',
  FAILED = 'failed',
  REFUNDED = 'refunded',
}

export enum PaymentMethod {
  CASH = 'cash',
  CARD = 'card',
  BANK_TRANSFER = 'bank_transfer',
  MOBILE_MONEY = 'mobile_money',
  PAYPAL = 'paypal',
}

export enum ShippingStatus {
  PENDING = 'pending',
  PACKED = 'packed',
  SHIPPED = 'shipped',
  DELIVERED = 'delivered',
  CANCELLED = 'cancelled',
}
