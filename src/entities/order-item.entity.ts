export interface OrderItemEntity {
  id?: string;
  order_id: string;
  product_id: string;
  quantity: number;
  price: number;
  subtotal: number;
  created_at?: string;
  updated_at?: string;
}