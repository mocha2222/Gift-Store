import { Injectable } from '@nestjs/common';
import { ProductsService } from '../products/products.service';

/** 4-question gift finder quiz → product recommendations */
@Injectable()
export class GiftQuizService {
  constructor(private productsService: ProductsService) {}

  getQuestions() {
    return [
      {
        id: 1,
        question: 'Who is this gift for?',
        key: 'recipient',
        options: [
          { value: 'him', label: 'For Him' },
          { value: 'her', label: 'For Her' },
          { value: 'couple', label: 'Couple' },
          { value: 'family', label: 'Family' },
        ],
      },
      {
        id: 2,
        question: 'What is the occasion?',
        key: 'occasion',
        options: [
          { value: 'wedding', label: 'Wedding' },
          { value: 'new_year', label: 'Khmer New Year' },
          { value: 'tourist', label: 'Souvenir / Tourist' },
          { value: 'everyday', label: 'Everyday' },
        ],
      },
      {
        id: 3,
        question: 'What is your budget?',
        key: 'budget',
        options: [
          { value: 'under25', label: 'Under $25' },
          { value: '25to75', label: '$25 – $75' },
          { value: 'over75', label: 'Over $75' },
        ],
      },
      {
        id: 4,
        question: 'Preferred craft style?',
        key: 'style',
        options: [
          { value: 'Textile', label: 'Textile / Silk' },
          { value: 'Silver', label: 'Silver' },
          { value: 'Wood', label: 'Wood' },
          { value: 'Jewelry', label: 'Jewelry' },
        ],
      },
    ];
  }

  submitAnswers(answers: {
    recipient?: string;
    occasion?: string;
    budget?: string;
    style?: string;
  }) {
    return this.productsService.giftFinder(answers);
  }
}
