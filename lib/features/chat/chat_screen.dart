import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';

/// Chat screen - AI assistant for invoice queries
/// 
/// Features:
/// - Chat interface
/// - AI-powered responses
/// - Invoice context awareness
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ThemedAppBar(
        title: l10n.chat,
        centerTitle: false,
        actions: [
          AppBarAction(
            icon: Icons.more_vert,
            onPressed: () {},
            tooltip: 'More options',
          ),
        ],
      ),
      body: EmptyState.noChatHistory(
        ctaLabel: 'Start Chat',
        onCtaPressed: () {
          // Show chat input
        },
      ),
    );
  }
}
