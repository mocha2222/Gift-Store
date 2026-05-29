export interface CollectionEntity {
  id?: string;
  title: string;
  description?: string;
  cover_image?: string;
  // product relationships are stored in collection_products collection
  created_at?: string;
  updated_at?: string;
}
