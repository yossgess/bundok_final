import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Themed scaffold with consistent background and structure
/// 
/// Features:
/// - Consistent backgroundColor: AppColors.background
/// - Optional appBar with theming
/// - Optional bottomNavigationBar
/// - Optional floating action button
/// - Safe area handling
/// - Keyboard resize behavior
class ThemedScaffold extends StatelessWidget {
  /// Main body content
  final Widget body;
  
  /// Optional app bar
  final PreferredSizeWidget? appBar;
  
  /// Optional bottom navigation bar
  final Widget? bottomNavigationBar;
  
  /// Optional floating action button
  final Widget? floatingActionButton;
  
  /// Floating action button location
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  
  /// Optional drawer
  final Widget? drawer;
  
  /// Optional end drawer
  final Widget? endDrawer;
  
  /// Whether to resize body when keyboard appears
  final bool? resizeToAvoidBottomInset;
  
  /// Whether to extend body behind app bar
  final bool extendBodyBehindAppBar;
  
  /// Whether to extend body behind bottom navigation bar
  final bool extendBody;
  
  /// Optional background color override
  final Color? backgroundColor;
  
  /// Whether to apply safe area
  final bool useSafeArea;
  
  /// Safe area minimum padding
  final EdgeInsets safeAreaMinimum;

  const ThemedScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.resizeToAvoidBottomInset,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.backgroundColor,
    this.useSafeArea = true,
    this.safeAreaMinimum = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    Widget scaffoldBody = body;
    
    // Apply safe area if needed
    if (useSafeArea) {
      scaffoldBody = SafeArea(
        minimum: safeAreaMinimum,
        child: body,
      );
    }
    
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: appBar,
      body: scaffoldBody,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
    );
  }
}

/// Themed scaffold with scrollable body
class ThemedScrollableScaffold extends StatelessWidget {
  /// Scrollable body content (list of widgets)
  final List<Widget> children;
  
  /// Optional app bar
  final PreferredSizeWidget? appBar;
  
  /// Optional bottom navigation bar
  final Widget? bottomNavigationBar;
  
  /// Optional floating action button
  final Widget? floatingActionButton;
  
  /// Floating action button location
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  
  /// Scroll controller
  final ScrollController? controller;
  
  /// Scroll physics
  final ScrollPhysics? physics;
  
  /// Padding around the scrollable content
  final EdgeInsetsGeometry? padding;
  
  /// Cross axis alignment for children
  final CrossAxisAlignment crossAxisAlignment;
  
  /// Main axis alignment for children
  final MainAxisAlignment mainAxisAlignment;
  
  /// Optional background color override
  final Color? backgroundColor;
  
  /// Whether to apply safe area
  final bool useSafeArea;

  const ThemedScrollableScaffold({
    super.key,
    required this.children,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.controller,
    this.physics,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.backgroundColor,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor,
      useSafeArea: useSafeArea,
      body: SingleChildScrollView(
        controller: controller,
        physics: physics,
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: children,
        ),
      ),
    );
  }
}

/// Themed scaffold with custom scroll view (for slivers)
class ThemedSliverScaffold extends StatelessWidget {
  /// Sliver widgets
  final List<Widget> slivers;
  
  /// Optional floating app bar (sliver)
  final Widget? sliverAppBar;
  
  /// Optional bottom navigation bar
  final Widget? bottomNavigationBar;
  
  /// Optional floating action button
  final Widget? floatingActionButton;
  
  /// Scroll controller
  final ScrollController? controller;
  
  /// Scroll physics
  final ScrollPhysics? physics;
  
  /// Optional background color override
  final Color? backgroundColor;

  const ThemedSliverScaffold({
    super.key,
    required this.slivers,
    this.sliverAppBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.controller,
    this.physics,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: CustomScrollView(
        controller: controller,
        physics: physics,
        slivers: [
          if (sliverAppBar != null) sliverAppBar!,
          ...slivers,
        ],
      ),
    );
  }
}

/// Themed scaffold with tab bar
class ThemedTabScaffold extends StatelessWidget {
  /// Tab controller
  final TabController controller;
  
  /// Tab labels
  final List<Widget> tabs;
  
  /// Tab views
  final List<Widget> tabViews;
  
  /// Optional app bar title
  final Widget? title;
  
  /// Optional app bar actions
  final List<Widget>? actions;
  
  /// Optional bottom navigation bar
  final Widget? bottomNavigationBar;
  
  /// Tab bar indicator color
  final Color? indicatorColor;
  
  /// Tab bar label color
  final Color? labelColor;
  
  /// Tab bar unselected label color
  final Color? unselectedLabelColor;
  
  /// Optional background color override
  final Color? backgroundColor;

  const ThemedTabScaffold({
    super.key,
    required this.controller,
    required this.tabs,
    required this.tabViews,
    this.title,
    this.actions,
    this.bottomNavigationBar,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.secondary,
        elevation: 0,
        title: title,
        actions: actions,
        bottom: TabBar(
          controller: controller,
          tabs: tabs,
          indicatorColor: indicatorColor ?? AppColors.primary,
          labelColor: labelColor ?? AppColors.secondary,
          unselectedLabelColor: unselectedLabelColor ?? 
              AppColors.secondary.withOpacity(0.6),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      body: TabBarView(
        controller: controller,
        children: tabViews,
      ),
    );
  }
}
