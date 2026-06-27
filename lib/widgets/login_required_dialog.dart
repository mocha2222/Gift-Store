import 'package:flutter/material.dart';
import '../router/app_router.dart';

/// Shows a dialog telling the user they need to log in to perform this action.
void showLoginRequiredDialog(BuildContext context, {String? action}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Login Required'),
      content: Text(
        action != null
            ? 'Please log in to $action.'
            : 'Please log in to continue.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).pushNamed(AppRoutes.login);
          },
          child: const Text('Log In'),
        ),
      ],
    ),
  );
}
