import 'package:flutter/material.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F0E4),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Your Cart',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF8C6500),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF8C6500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'lib/assets/images/Angkor Sunset Hand-Woven Scarf.png',
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Angkor Sunset Hand-Woven Scarf',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$85.00',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: const [
                        Icon(Icons.delete_outline, color: Colors.redAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  'Continue to customise your gift order with packaging and delivery options.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16, // 🔧 make it bigger
                    fontWeight: FontWeight.w500,
                    color: Colors.black87, // adjust color if needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8C6500),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CheckoutPage())),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
