/// Core UI Primitives - Barrel Export File
/// 
/// This file provides convenient access to all shared widgets.
/// Import this single file to access all UI components.
/// 
/// Usage:
/// ```dart
/// import 'package:bundok_final/shared/widgets/widgets.dart';
/// ```

// Typography
export 'typography/themed_text.dart';

// Icons
export 'icons/themed_icon.dart';

// Buttons
export 'buttons/primary_button.dart';
export 'buttons/secondary_button.dart';
export 'buttons/text_button.dart';

// Inputs
export 'inputs/themed_text_input.dart';

// Chips
export 'chips/tag_chip.dart' hide FilterChip;

// Badges
export 'badges/status_badge.dart';

// Dividers
export 'dividers/themed_divider.dart';

// Loaders
export 'loaders/skeleton_loader.dart';

// Layout
export 'layout/themed_scaffold.dart';
export 'layout/themed_app_bar.dart';
export 'layout/section_header.dart';

// Containers
export 'containers/card_container.dart';

// Data Display
export 'data_display/invoice_card.dart';
export 'data_display/invoice_line_item.dart';
export 'data_display/key_value_row.dart';
export 'data_display/document_preview.dart';
export 'data_display/empty_state.dart';

// Form Controls
export 'form_controls/editable_field.dart';
export 'form_controls/tag_input.dart';
export 'form_controls/date_picker_field.dart';
export 'form_controls/currency_input.dart';
export 'form_controls/search_bar.dart';

// Navigation
export 'navigation/filter_chip.dart';
export 'navigation/segmented_control.dart';
export 'navigation/bottom_navigation_item.dart';
export 'navigation/themed_fab.dart';
