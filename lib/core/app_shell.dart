import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import '../core/constants/app_colors.dart';
import '../core/l10n/app_localizations.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/invoices/folders_screen.dart';
import '../features/scan_document/presentation/scan_preview_screen.dart';
import '../features/scan_document/utils/scan_permissions.dart';
import '../features/chat/chat_screen.dart';
import 'settings_screen.dart';

/// Main app shell with bottom navigation
/// 
/// Features:
/// - 5 tabs: Dashboard, Folders, Scan (center FAB), Chat, Settings
/// - Persistent bottom navigation
/// - Larger scan button in center
/// - Localized labels
/// - RTL support
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  // Screen list (scan is handled separately via FAB)
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardScreen(),
      const FoldersScreen(),
      const SizedBox(), // Placeholder for scan (index 2)
      const ChatScreen(),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) async {
    // Handle scan button (index 2) separately
    if (index == 2) {
      await _handleScan();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Handle document scan - directly opens ML Kit scanner
  Future<void> _handleScan() async {
    // Check camera permission
    final hasPermission = await ScanPermissions.hasCameraPermission();
    
    if (!hasPermission) {
      final granted = await ScanPermissions.requestCameraPermission();
      
      if (!granted) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.scanCameraPermissionDenied),
              backgroundColor: AppColors.error,
              action: SnackBarAction(
                label: l10n.scanOpenSettings,
                textColor: Colors.white,
                onPressed: () => ScanPermissions.openSettings(),
              ),
            ),
          );
        }
        return;
      }
    }

    try {
      debugPrint('[AppShell] 🚀 Launching document scanner...');
      
      // Use cunning_document_scanner which returns image paths directly
      final scannedImages = await CunningDocumentScanner.getPictures(
        noOfPages: 1, // Single page scan
      );

      debugPrint('[AppShell] Scanner returned: $scannedImages');
      debugPrint('[AppShell] Type: ${scannedImages.runtimeType}');

      if (scannedImages != null && scannedImages.isNotEmpty && mounted) {
        // Get the first scanned image path
        String imagePath = scannedImages.first;
        debugPrint('[AppShell] ✅ Got image path: $imagePath');
        
        debugPrint('[AppShell] 📱 Navigating to preview screen...');
        
        // Navigate to preview screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanPreviewScreen(
              capturedImage: File(imagePath),
            ),
          ),
        );
        
        debugPrint('[AppShell] ✅ Returned from preview screen');
      } else {
        debugPrint('[AppShell] ❌ Scanner returned null or empty list');
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.scanFailedMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(l10n),
      floatingActionButton: _buildScanFAB(l10n),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Build bottom navigation bar with center gap
  Widget _buildBottomNavigationBar(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              // Dashboard
              Expanded(
                child: _buildNavItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  label: l10n.dashboard,
                  index: 0,
                ),
              ),
              
              // Folders
              Expanded(
                child: _buildNavItem(
                  icon: Icons.folder_outlined,
                  activeIcon: Icons.folder,
                  label: l10n.invoices,
                  index: 1,
                ),
              ),
              
              // Center gap for FAB
              const SizedBox(width: 72),
              
              // Chat
              Expanded(
                child: _buildNavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: l10n.chat,
                  index: 3,
                ),
              ),
              
              // Settings
              Expanded(
                child: _buildNavItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: l10n.settings,
                  index: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build individual navigation item
  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.secondary.withOpacity(0.5);

    return InkWell(
      onTap: () => _onItemTapped(index),
      splashColor: AppColors.primary.withOpacity(0.1),
      highlightColor: AppColors.primary.withOpacity(0.05),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with background
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.primary.withOpacity(0.12) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 24,
                color: color,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
                letterSpacing: 0.1,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build scan FAB (larger, centered)
  Widget _buildScanFAB(AppLocalizations l10n) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(2),
          borderRadius: BorderRadius.circular(30),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(2),
              child: const Icon(
                Icons.document_scanner,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
