export interface CouponEntity {
  id?: string;
  code: string;
  discount: number;
  start_date: Date;
  end_date: Date;
  created_at?: string;
  updated_at?: string;
}
