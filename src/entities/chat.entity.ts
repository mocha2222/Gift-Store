export interface ChatEntity {
  id?: string;
  sender_id: string;
  receiver_id: string;
  message: string;
  sent_at?: string;
}
