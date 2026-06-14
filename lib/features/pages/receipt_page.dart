import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F0E4),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Digital Receipt',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF8C6500),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF8C6500)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    size: 64,
                    color: Color(0xFF8C6500),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Order Receipt',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F453A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${_getTodayDate()} | Order: #ORD-1029384756',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6F5B46),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Itemized List
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEDE1CB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Items Purchased',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const Divider(height: 24, thickness: 1.2),
                  _ReceiptItemRow(
                    title: 'Premium Gift 1',
                    qty: 2,
                    price: '\$49.98',
                  ),
                  const SizedBox(height: 12),
                  _ReceiptItemRow(
                    title: 'Elegant Wrapping Paper',
                    qty: 1,
                    price: '\$5.99',
                  ),
                  const SizedBox(height: 12),
                  _ReceiptItemRow(
                    title: 'Custom Ribbon',
                    qty: 1,
                    price: '\$3.50',
                  ),
                  const Divider(height: 32, thickness: 1.2),

                  // Totals Breakdown
                  _ReceiptSummaryRow(label: 'Subtotal', value: '\$59.47'),
                  const SizedBox(height: 8),
                  _ReceiptSummaryRow(label: 'Shipping', value: '\$5.00'),
                  const SizedBox(height: 8),
                  _ReceiptSummaryRow(label: 'Tax (8%)', value: '\$4.76'),
                  const Divider(height: 24, thickness: 1.2),
                  _ReceiptSummaryRow(
                    label: 'Total Paid',
                    value: '\$69.23',
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7EC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE3D3BE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4F453A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.credit_card, color: Color(0xFF8C6500)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Visa ending in 4242',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5E4C3D),
                            ),
                          ),
                          Text(
                            'Auth Code: 88291A',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6F5B46),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8C6500),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Return to home or pop route
                Navigator.of(context).pop();
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTodayDate() {
    final now = DateTime.now();
    return '${now.month}/${now.day}/${now.year}';
  }
}

class _ReceiptItemRow extends StatelessWidget {
  final String title;
  final int qty;
  final String price;

  const _ReceiptItemRow({
    required this.title,
    required this.qty,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${qty}x ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8C6500),
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF5E4C3D)),
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4F453A),
          ),
        ),
      ],
    );
  }
}

class _ReceiptSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _ReceiptSummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF4F453A),
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            color: isBold ? const Color(0xFF8C6500) : const Color(0xFF4F453A),
          ),
        ),
      ],
    );
  }
}
