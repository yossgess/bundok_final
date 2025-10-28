import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';

/// Dashboard screen - Main overview
/// 
/// Features:
/// - Invoice statistics
/// - Recent invoices
/// - Quick actions
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ThemedAppBar(
        title: l10n.dashboard,
        centerTitle: false,
        actions: [
          AppBarAction(
            icon: Icons.notifications_outlined,
            onPressed: () {},
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            ThemedText.headlineMedium(
              'Welcome back! 👋',
              color: AppColors.secondary,
            ),
            const SizedBox(height: 8),
            ThemedText.bodyMedium(
              'Here\'s an overview of your invoices',
              color: AppColors.text.withOpacity(0.7),
            ),
            
            const SizedBox(height: 24),
            
            // Stats cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.receipt_long,
                    label: 'Total Invoices',
                    value: '0',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.pending_actions,
                    label: 'Pending',
                    value: '0',
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Quick actions
            ThemedText.titleLarge(
              'Quick Actions',
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            
            _buildQuickAction(
              icon: Icons.document_scanner,
              title: 'Scan Invoice',
              subtitle: 'Capture a new invoice',
              color: AppColors.primary,
              onTap: () {
                // Navigation handled by bottom nav
              },
            ),
            
            const SizedBox(height: 12),
            
            _buildQuickAction(
              icon: Icons.chat_bubble_outline,
              title: 'Ask AI Assistant',
              subtitle: 'Get insights about your invoices',
              color: AppColors.accent,
              onTap: () {
                // Navigation handled by bottom nav
              },
            ),
            
            const SizedBox(height: 32),
            
            // Recent invoices section
            ThemedText.titleLarge(
              'Recent Invoices',
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            
            EmptyState.noInvoices(
              ctaLabel: 'Scan Your First Invoice',
              onCtaPressed: () {
                // Navigation handled by bottom nav
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return CardContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          ThemedText.displaySmall(
            value,
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          ThemedText.bodySmall(
            label,
            color: AppColors.text.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CardContainer(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ThemedText.titleMedium(
                    title,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  ThemedText.bodySmall(
                    subtitle,
                    color: AppColors.text.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.text,
            ),
          ],
        ),
      ),
    );
  }
}
