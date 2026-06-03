export interface CartItemEntity {
  id?: string;
  cart_id: string;
  product_id: string;
  quantity: number;
  price: number;
  subtotal: number;
  created_at?: string;
  updated_at?: string;
}