import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Profile Screen - Placeholder
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 80,
              color: AppColors.onSurfaceSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Profile feature not implemented yet',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
