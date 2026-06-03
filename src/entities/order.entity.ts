export interface OrderEntity {
  id?: string;
  user_id: string;
  total_price: number;
  delivery_date?: string;
  gift_wrap?: boolean;
  personal_message?: string;
  status?: string;
  coupon_code?: string;
  created_at?: string;
  updated_at?: string;
}
