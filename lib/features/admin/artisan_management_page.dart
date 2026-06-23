import 'package:flutter/material.dart';

import '../../services/auth_api.dart';
import '../../services/admin_api.dart';
import 'admin_models.dart';
import 'widgets/artisan_widgets.dart';

class ArtisanManagementPage extends StatefulWidget {
  const ArtisanManagementPage({super.key});

  @override
  State<ArtisanManagementPage> createState() => _ArtisanManagementPageState();
}

class _ArtisanManagementPageState extends State<ArtisanManagementPage> {

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
                    itemCount: adminArtisans.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: 220,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) {
                      final artisan = adminArtisans[index];
                      return ArtisanCard(
                        artisan: artisan,
                        onView: () => _showProfileDialog(artisan),
                        onToggle: artisan.id.isEmpty ? null : () async {
                          final nextStatus = artisan.status == AdminArtisanStatus.suspended
                              ? AdminArtisanStatus.active
                              : AdminArtisanStatus.suspended;
                          try {
                            await AdminApi.suspendArtisan(artisan.id, artisan.userId, nextStatus);
                            setState(() {
                              adminArtisans[index] = artisan.copyWith(status: nextStatus);
                            });
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                            }
                          }
                        },
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
    final streetController = TextEditingController();
    final houseNumberController = TextEditingController();
    final districtController = TextEditingController();
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
                  Row(
                    children: [
                      Expanded(child: TextField(controller: houseNumberController, decoration: const InputDecoration(labelText: 'House #'))),
                      const SizedBox(width: 8),
                      Expanded(flex: 2, child: TextField(controller: streetController, decoration: const InputDecoration(labelText: 'Street'))),
                    ],
                  ),
                  TextField(controller: districtController, decoration: const InputDecoration(labelText: 'District')),
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
                    
                    final location = [houseNumberController.text.trim(), streetController.text.trim(), districtController.text.trim()]
                        .where((e) => e.isNotEmpty)
                        .join(', ');
                        
                    // Reload data from backend to get the newly created artisan's real ID
                    await AdminApi.loadAdminData();
                    setState(() {});
                    
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
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFFF1C766),
                backgroundImage: artisan.profileImage != null && artisan.profileImage!.isNotEmpty
                    ? (artisan.profileImage!.startsWith('data:') || artisan.profileImage!.length > 200
                        ? MemoryImage(decodeProfileImage(artisan.profileImage!))
                        : NetworkImage(artisan.profileImage!) as ImageProvider)
                    : null,
                child: artisan.profileImage == null || artisan.profileImage!.isEmpty
                    ? Text(
                        artisan.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF7B5200)),
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(artisan.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${artisan.role} • ${artisan.location}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProfileStat(label: 'Products', value: artisan.products.toString()),
                  _ProfileStat(label: 'Followers', value: artisan.followers.toString()),
                  _ProfileStat(label: 'Status', value: artisanStatusLabel(artisan.status)),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
