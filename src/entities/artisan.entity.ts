export interface ArtisanEntity {
  id?: string;
  user_id: string;
  shop_name: string;
  region?: string;
  craft_type?: string;
  story?: string;
  shop_location?: string;
  latitude?: number;
  longitude?: number;
  cover_image?: string;
  created_at?: string;
  updated_at?: string;
}
