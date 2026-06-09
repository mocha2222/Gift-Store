import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_mock_data.dart';
import 'shop_bottom_sheet.dart';

class MapView extends StatefulWidget {
  const MapView({
    super.key,
    required this.shops,
    required this.selectedCategory,
  });

  final List<ShopLocation> shops;
  final String selectedCategory;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _mapController = MapController();

  static const _categoryColors = {
    'Silk':    Color(0xFF6B4C9A),
    'Silver':  Color(0xFF5B7FA6),
    'Wood':    Color(0xFF7A5230),
    'Edible':  Color(0xFF4A7C59),
    'Jewelry': Color(0xFFB8770D),
  };

  final _cambodiaCenter = LatLng(12.5657, 104.9910);

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _cambodiaCenter,
              initialZoom: 7.0,
              minZoom: 5.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.giftstore',
                maxZoom: 18,
              ),

              MarkerLayer(
                markers: widget.shops.map((shop) {
                  final color = _categoryColors[shop.category]
                      ?? const Color(0xFFB8770D);
                  return Marker(
                    point: LatLng(shop.lat, shop.lng),
                    width: 48,
                    height: 56,
                    child: GestureDetector(
                      onTap: () =>
                          ShopBottomSheet.show(context, shop),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  // ← fix 4: withValues instead of withOpacity
                                  color: color.withValues(alpha: 0.45),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.store_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          Container(
                            width: 2.5,
                            height: 10,
                            color: color,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          Positioned(
            top: 12, right: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _ZoomButton(
                    icon: Icons.add,
                    isTop: true,
                    onTap: () => _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    ),
                  ),
                  Container(
                    height: 0.5,
                    width: 36,
                    color: const Color(0xFFEAD5A8),
                  ),
                  _ZoomButton(
                    icon: Icons.remove,
                    isTop: false,
                    onTap: () => _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 12, right: 12,
            child: GestureDetector(
              onTap: () => _mapController.move(_cambodiaCenter, 7.0),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.my_location_rounded,
                    color: Color(0xFFB8770D), size: 20),
              ),
            ),
          ),

          Positioned(
            bottom: 8, left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '© OpenStreetMap contributors',
                style: TextStyle(
                    fontSize: 8, color: Color(0xFF555555)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.icon,
    required this.onTap,
    required this.isTop,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top:    isTop ? const Radius.circular(10) : Radius.zero,
            bottom: isTop ? Radius.zero : const Radius.circular(10),
          ),
        ),
        child: Icon(icon, size: 20,
            color: const Color(0xFF5E4A35)),
      ),
    );
  }
}