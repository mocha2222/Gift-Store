import 'package:flutter/material.dart';
import 'map_mock_data.dart';
import 'shop_bottom_sheet.dart';

class MapView extends StatelessWidget {
  const MapView({
    super.key,
    required this.shops,
    required this.selectedCategory,
  });

  final List<ShopLocation> shops;
  final String selectedCategory;

  static const _categoryColors = {
    'Silk':    Color(0xFF6B4C9A),
    'Silver':  Color(0xFF5B7FA6),
    'Wood':    Color(0xFF7A5230),
    'Edible':  Color(0xFF4A7C59),
    'Jewelry': Color(0xFFB8770D),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8E0D0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4C4A8)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _MapGridPainter(),
            ),

            Positioned(
              top: 12, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(children: [
                  Icon(Icons.map_outlined,
                      size: 14, color: Color(0xFFB8770D)),
                  SizedBox(width: 6),
                  Text('Cambodia · Shop Locations',
                      style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: Color(0xFF5E4A35),
                      )),
                ]),
              ),
            ),

            ...shops.map((shop) => _buildPin(context, shop)),

            Positioned(
              bottom: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(children: [
                  Icon(Icons.add, size: 18, color: Color(0xFF5E4A35)),
                  SizedBox(height: 4),
                  Icon(Icons.remove, size: 18, color: Color(0xFF5E4A35)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPin(BuildContext context, ShopLocation shop) {
    final latRange  = 13.8 - 10.4; 
    final lngRange  = 107.6 - 102.3;
    final xFrac = (shop.lng - 102.3) / lngRange;
    final yFrac = 1.0 - (shop.lat - 10.4) / latRange;

    final color = _categoryColors[shop.category] ?? const Color(0xFFB8770D);

    return Positioned(

      left: xFrac * 280 + 20,
      top: yFrac * 180 + 20,
      child: GestureDetector(
        onTap: () => ShopBottomSheet.show(context, shop),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 6, offset: const Offset(0, 2),
                )],
              ),
              child: Text(shop.name.split(' ').first,
                  style: TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w700,
                    color: color,
                  )),
            ),
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8, offset: const Offset(0, 3),
                )],
              ),
              child: const Icon(Icons.store_rounded,
                  color: Colors.white, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCFC4B0).withOpacity(0.4)
      ..strokeWidth = 0.5;

    for (var y = 0.0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (var x = 0.0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    final road = Paint()
      ..color = const Color(0xFFD4C4A8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.55), road);
    canvas.drawLine(Offset(size.width * 0.3, 0),
        Offset(size.width * 0.45, size.height), road);
    canvas.drawLine(Offset(size.width * 0.7, 0),
        Offset(size.width * 0.6, size.height), road);
  }

  @override
  bool shouldRepaint(_) => false;
}