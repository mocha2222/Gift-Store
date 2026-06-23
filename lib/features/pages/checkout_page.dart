import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../router/app_router.dart';
import '../../services/cart_service.dart';
import '../../services/product_api.dart';
import 'package:flutter/services.dart';

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // If deleting and we just deleted a slash, handle deletion of the preceding digit
    if (oldValue.text.length > newValue.text.length && oldValue.text.endsWith('/') && cleanText.length == 2) {
      final text = cleanText.substring(0, 1);
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    var formattedText = '';
    if (cleanText.length >= 1) {
      formattedText += cleanText.substring(0, cleanText.length >= 2 ? 2 : cleanText.length);
    }
    if (cleanText.length > 2) {
      formattedText += '/' + cleanText.substring(2, cleanText.length >= 4 ? 4 : cleanText.length);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _isAccountPresent = false;
  bool _useSameAddress = true;

  @override
  void initState() {
    super.initState();
    _loadAccountStatus();
  }

  Future<void> _loadAccountStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isAccountPresent = prefs.getString('user_email') != null;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  /// A valid MongoDB ObjectId is exactly 24 hex characters.
  static final _mongoIdRegex = RegExp(r'^[a-fA-F0-9]{24}$');

  Future<bool> _saveOrder({
    required String orderId,
    required String name,
    required String address,
    required String total,
    required CartService cart,
  }) async {
    try {
      // Log all product IDs for debugging
      for (final item in cart.items) {
        debugPrint('[Checkout] Cart item: id="${item.item.id}", title="${item.item.title}", qty=${item.quantity}');
      }

      // Only include items with valid MongoDB ObjectIds
      final validItems = cart.items.where((item) => _mongoIdRegex.hasMatch(item.item.id)).toList();
      final skippedCount = cart.items.length - validItems.length;

      if (skippedCount > 0) {
        debugPrint('[Checkout] Skipped $skippedCount item(s) with invalid product IDs');
      }

      if (validItems.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid products in cart. Please add products from the store.')),
          );
        }
        return false;
      }

      final items = validItems.map((item) => {
        'product_id': item.item.id,
        'quantity': item.quantity,
      }).toList();

      final payload = {
        'items': items,
      };

      debugPrint('[Checkout] Sending order payload: ${payload.toString()}');
      
      await ProductApi.createOrder(payload);
      return true;
    } catch (e) {
      debugPrint('Error saving order: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
      return false;
    }
  }

  Future<void> _placeOrder(CartService cart) async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isAccountPresent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create an account to complete your order.'),
        ),
      );
      return;
    }

    final orderId = 'ORD-${(DateTime.now().millisecondsSinceEpoch % 1000000000).toString().padLeft(9, '0')}';
    final name = _nameCtrl.text;
    final address = _addressCtrl.text;
    final total = '\$${cart.total.toStringAsFixed(2)}';

    final success = await _saveOrder(
      orderId: orderId,
      name: name,
      address: address,
      total: total,
      cart: cart,
    );

    if (!success || !mounted) return;

    cart.clear();

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.checkoutDetails,
      arguments: CheckoutDetailsArgs(
        orderId: orderId,
        customerName: name,
        deliveryAddress: address,
        totalPaid: total,
        products: cart.items.map((i) => '${i.quantity} x ${i.item.title}').toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F0E4),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Checkout',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: const Color(0xFF8C6500)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF8C6500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isAccountPresent)
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFECB68B)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF8C6500)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sign up or log in to finish checkout and place your order. You can still fill payment information now.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFF6E5529)),
                        ),
                      ),
                    ],
                  ),
                ),
              if (cart.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEDE1CB)),
                  ),
                  child: const Text(
                    'Your cart is empty. Add gifts to your cart before placing an order.',
                    style: TextStyle(fontSize: 15, color: Color(0xFF6F5B46)),
                  ),
                )
              else
                _CheckoutSummary(cart: cart),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Billing details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _nameCtrl,
                      label: 'Full name',
                      validator: _notEmptyValidator,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _emailCtrl,
                      label: 'Email address',
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailValidator,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _addressCtrl,
                      label: 'Delivery address',
                      validator: _notEmptyValidator,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Payment details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _cardNumberCtrl,
                      label: 'Card number',
                      keyboardType: TextInputType.number,
                      validator: _cardValidator,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _expiryCtrl,
                            label: 'Expiry (MM/YY)',
                            keyboardType: TextInputType
                                .number, // Changing to number is often cleaner on iOS/Android for dates
                            validator: _expiryValidator,
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Only allow numbers
                              LengthLimitingTextInputFormatter(
                                5,
                              ), // Max 5 characters (MM/YY)
                              CardExpirationFormatter(), // Adds the '/' automatically
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _cvvCtrl,
                            label: 'CVV',
                            keyboardType: TextInputType.number,
                            validator: _cvvValidator,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _useSameAddress,
                          onChanged: (value) =>
                              setState(() => _useSameAddress = value ?? true),
                        ),
                        const Expanded(
                          child: Text('Use billing address for shipping'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8C6500),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: cart.isEmpty ? null : () => _placeOrder(cart),
                      child: Text(
                        _isAccountPresent ? 'Place Order' : 'Save and Sign Up',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!_isAccountPresent)
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed(AppRoutes.signup),
                        child: const Text('Create an account now'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _notEmptyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _cardValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Card number required';
    }
    if (value.replaceAll(' ', '').length < 12) {
      return 'Enter a valid card number';
    }
    return null;
  }

  String? _expiryValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }

    // Check if it matches the MM/YY format exactly
    final RegExp regex = RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$');
    if (!regex.hasMatch(value)) {
      return 'Use MM/YY format';
    }

    // Split month and year safely
    int month = 0;
    int year = 0;
    if (value.contains('/')) {
      final parts = value.split('/');
      if (parts.length >= 2) {
        month = int.tryParse(parts[0]) ?? 0;
        year = int.tryParse('20${parts[1]}') ?? 0;
      }
    } else if (value.length == 4) {
      month = int.tryParse(value.substring(0, 2)) ?? 0;
      year = int.tryParse('20${value.substring(2, 4)}') ?? 0;
    }

    if (month < 1 || month > 12 || year == 0) {
      return 'Use MM/YY format';
    }

    // Check against current date
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }

    return null; // Input is valid!
  }

  String? _cvvValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CVV required';
    }
    if (value.trim().length < 3) {
      return 'Enter 3 or 4 digits';
    }
    return null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

class _CheckoutSummary extends StatelessWidget {
  const _CheckoutSummary({required this.cart});

  final CartService cart;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Order summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity} x ${item.item.title}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5E4C3D),
                      ),
                    ),
                  ),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24, thickness: 1.2),
          _SummaryLine(
            label: 'Subtotal',
            value: '\$${cart.subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _SummaryLine(
            label: 'Shipping',
            value: cart.shipping == 0
                ? 'Free'
                : '\$${cart.shipping.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _SummaryLine(label: 'Tax', value: '\$${cart.tax.toStringAsFixed(2)}'),
          const Divider(height: 24, thickness: 1.2),
          _SummaryLine(
            label: 'Total',
            value: '\$${cart.total.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF4F453A),
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
            color: const Color(0xFF8C6500),
          ),
        ),
      ],
    );
  }
}
