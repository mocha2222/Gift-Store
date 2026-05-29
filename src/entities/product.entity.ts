export interface ProductEntity {
  id?: string;
  artisan_id: string;
  category_id: string;
  name: string;
  description?: string;
  price: number;
  stock?: number;
  material?: string;
  dimensions?: string;
  width?: number;
  height?: number;
  depth?: number;
  unit?: string;
  story?: string;
  image?: string;
  gift_for?: string;
  occasion?: string;
  created_at?: string;
  updated_at?: string;
}
