import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';

/// Folders/Invoices screen - Browse and manage invoices
/// 
/// Features:
/// - List of invoices
/// - Search and filter
/// - Folder organization
class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ThemedAppBar(
        title: l10n.invoices,
        centerTitle: false,
        actions: [
          AppBarAction(
            icon: Icons.search,
            onPressed: () {},
            tooltip: 'Search',
          ),
          AppBarAction(
            icon: Icons.filter_list,
            onPressed: () {},
            tooltip: 'Filter',
          ),
        ],
      ),
      body: EmptyState.noInvoices(
        ctaLabel: 'Scan Your First Invoice',
        onCtaPressed: () {
          // Navigation handled by bottom nav
        },
      ),
    );
  }
}
