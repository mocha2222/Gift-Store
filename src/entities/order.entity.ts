export interface OrderItemEntity {
  product_id: string;
  quantity: number;
  subtotal: number;
}

export interface OrderEntity {
  id?: string;
  user_id: string;
  items: OrderItemEntity[];
  total_price: number;
  delivery_date?: string;
  gift_wrap?: boolean;
  personal_message?: string;
  status?: string;
  coupon_code?: string;
  created_at?: string;
  updated_at?: string;
}
