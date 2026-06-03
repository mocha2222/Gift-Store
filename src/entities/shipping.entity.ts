export interface ShippingEntity {
  id?: string;
  order_id: string;
  recipient_name: string;
  phone?: string;
  address_line1: string;
  address_line2?: string;
  city?: string;
  state?: string;
  postal_code?: string;
  country?: string;
  tracking_number?: string;
  delivery_provider?: string;
  shipping_status?: string;
  shipped_at?: string;
  delivered_at?: string;
  created_at?: string;
  updated_at?: string;
}