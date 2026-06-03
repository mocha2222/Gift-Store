export interface PaymentEntity {
  id?: string;
  order_id: string;
  payment_method: string;
  transaction_status?: string;
  payment_reference?: string;
  amount: number;
  paid_at?: string;
  created_at?: string;
  updated_at?: string;
}