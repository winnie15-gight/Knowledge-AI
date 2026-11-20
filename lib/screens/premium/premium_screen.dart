import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Membership')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PREMIUM ACCESS', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 11)),
            const SizedBox(height: 8),
            const Text('Empower your learning', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.text)),
            const SizedBox(height: 12),
            const Text(
              'Unlock advanced learning modes, higher token limits, and deeper subject explanations.',
              style: TextStyle(color: AppColors.muted, height: 1.5),
            ),
            const SizedBox(height: 24),

            _buildTierCard(
              title: 'Scholar Free',
              price: 'Free',
              features: [
                'Unlimited standard questions',
                'Standard response times',
                'General tutor preferences',
              ],
              isCurrent: true,
            ),
            const SizedBox(height: 16),

            _buildTierCard(
              title: 'Scholar Pro',
              price: 'Coming Soon',
              features: [
                'Faster high-priority reasoning models',
                'Unlimited history retention',
                'Extended mathematical problem solver',
                'Dedicated academic guidance',
              ],
              isCurrent: false,
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.accent, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Paystack automated billing is currently under server integration testing. Payments will open in the next update.',
                      style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required String title,
    required String price,
    required List<String> features,
    required bool isCurrent,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCurrent ? AppColors.accent : AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF163B43), borderRadius: BorderRadius.circular(6)),
                  child: const Text('ACTIVE', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.accent)),
          const SizedBox(height: 16),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 16, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(child: Text(f, style: const TextStyle(color: AppColors.text, fontSize: 13))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
