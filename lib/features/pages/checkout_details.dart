import 'package:flutter/material.dart';

class CheckoutDetailsPage extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String deliveryAddress;
  final String totalPaid;
  final String? date;

  const CheckoutDetailsPage({
    super.key,
    // Default mock values for testing the UI before you connect real data
    this.orderId = 'ORD-1029384756',
    this.customerName = 'Guest User',
    this.deliveryAddress = '123 Flutter Way, App City, 10001',
    this.totalPaid = '\$0.00',
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F0E4),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Order Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF8C6500),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF8C6500)),
        automaticallyImplyLeading: false, // Prevents going back to checkout
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // Success Icon and Header
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: Color(0xFF8C6500),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank you for your order!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F453A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A confirmation email has been sent to you. We will notify you when your order ships.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xFF6F5B46),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            // Order Information Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDE1CB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4F453A),
                    ),
                  ),
                  const Divider(height: 24, thickness: 1.2),
                  _DetailRow(label: 'Order Number', value: orderId),
                  const SizedBox(height: 12),
                  _DetailRow(label: 'Date', value: date ?? _getTodayDate()),
                  const SizedBox(height: 12),
                  _DetailRow(
                    label: 'Total Paid',
                    value: totalPaid,
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Shipping Information Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7EC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE3D3BE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shipping To',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4F453A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    customerName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5E4C3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deliveryAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6F5B46),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

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
                // Navigate back to the home screen or catalog
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Future functionality: View digital receipt or order history
              },
              child: const Text(
                'View Receipt',
                style: TextStyle(
                  color: Color(0xFF8C6500),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Helper method to generate today's date for the mockup
  String _getTodayDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}

// Helper widget for displaying rows of data
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6F5B46)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? const Color(0xFF8C6500) : const Color(0xFF4F453A),
            ),
          ),
        ),
      ],
    );
  }
}
