import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';

class PresidentPage extends StatelessWidget {
  const PresidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    ///
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        children: [
          // Image bmb
          Image.asset('assets/image_bmb_pdt.webp', fit: BoxFit.cover),

          // some words
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // headline
                  Text('Mot du président', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),

                  // body text
                  Text(
                    'Lorem ipsum dolor sit amet consectetur. Velit pharetra ac amet vel in rhoncus sodales tempor faucibus. Quam pharetra orci nunc mauris euismod id semper. Suspendisse morbi integer sagittis viverra blandit sed sed est. Scelerisque nisl diam facilisi velit et. Lacus in blandit amet elit vitae. Pharetra blandit curabitur purus arcu molestie quam massa viverra quisque. A libero auctor sodales aliquam pellentesque. Mi pretium placerat nulla vitae et lacus urna diam.',
                    softWrap: true,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
