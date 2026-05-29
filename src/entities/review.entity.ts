export interface ReviewEntity {
  id?: string;
  user_id: string;
  product_id: string;
  rating: number;
  comment?: string;
  photo?: string;
  created_at?: string;
  updated_at?: string;
}
