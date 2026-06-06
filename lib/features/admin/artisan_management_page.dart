import 'package:flutter/material.dart';

import '../../services/auth_api.dart';
import 'admin_models.dart';
import 'widgets/artisan_widgets.dart';

class ArtisanManagementPage extends StatefulWidget {
  const ArtisanManagementPage({super.key});

  @override
  State<ArtisanManagementPage> createState() => _ArtisanManagementPageState();
}

class _ArtisanManagementPageState extends State<ArtisanManagementPage> {
  late final List<AdminArtisan> _artisans = List.of(adminArtisans);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArtisanToolbar(
                title: 'Artisan Management',
                subtitle: 'Create artisan accounts, inspect profiles, and manage activation status.',
                actionLabel: 'Create artisan account',
                onAction: _showCreateDialog,
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 980 ? 2 : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _artisans.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: 220,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) {
                      final artisan = _artisans[index];
                      return ArtisanCard(
                        artisan: artisan,
                        onView: () => _showProfileDialog(artisan),
                        onToggle: () => setState(() {
                          final nextStatus = artisan.status == AdminArtisanStatus.suspended
                              ? AdminArtisanStatus.active
                              : AdminArtisanStatus.suspended;
                          _artisans[index] = artisan.copyWith(status: nextStatus);
                        }),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final locationController = TextEditingController();
    bool isCreating = false;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateBuilder) {
          return AlertDialog(
            title: const Text('Create artisan account'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Artisan name')),
                  TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                  TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                  TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              FilledButton(
                onPressed: isCreating ? null : () async {
                  if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) return;
                  
                  setStateBuilder(() => isCreating = true);
                  try {
                    await AuthApi.register(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text,
                      role: 'artisan',
                    );
                    
                    setState(() {
                      _artisans.insert(
                        0,
                        AdminArtisan(
                          name: nameController.text.trim(),
                          role: 'Artisan',
                          location: locationController.text.trim().isEmpty ? 'Unknown' : locationController.text.trim(),
                          status: AdminArtisanStatus.pendingSetup,
                          products: 0,
                          followers: 0,
                        ),
                      );
                    });
                    if (context.mounted) Navigator.of(context).pop();
                  } catch (e) {
                    setStateBuilder(() => isCreating = false);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                    }
                  }
                },
                child: isCreating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Create'),
              ),
            ],
          );
        }
      ),
    );
  }

  void _showProfileDialog(AdminArtisan artisan) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(artisan.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Role: ${artisan.role}'),
            Text('Location: ${artisan.location}'),
            Text('Products: ${artisan.products}'),
            Text('Followers: ${artisan.followers}'),
            const SizedBox(height: 8),
            Text('Status: ${artisanStatusLabel(artisan.status)}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }
}
