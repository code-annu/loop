import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Search Screen - Placeholder
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Search',
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
              Icons.search,
              size: 80,
              color: AppColors.onSurfaceSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Search feature not implemented yet',
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
