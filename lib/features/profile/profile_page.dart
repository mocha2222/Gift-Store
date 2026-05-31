import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer_profile_page.dart';
import 'guest_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.showAppBar = false});

  final bool showAppBar;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final Future<SharedPreferences> _prefsFuture;

  @override
  void initState() {
    super.initState();
    _prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return GuestProfilePage(showAppBar: widget.showAppBar);
        }

        final email = snapshot.data!.getString('user_email') ?? '';
        if (email.isEmpty) {
          return GuestProfilePage(showAppBar: widget.showAppBar);
        }

        return CustomerProfilePage(showAppBar: widget.showAppBar);
      },
    );
  }
}
