import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../chips/tag_chip.dart' as chips;

/// Tag input component with chip display
/// 
/// Features:
/// - User types → press "Enter" → adds TagChip
/// - Supports deletion by clicking X or backspace
/// - Visual chip display
/// - Optional suggestions/autocomplete
/// - Maximum tag limit support
class TagInput extends StatefulWidget {
  /// Initial tags
  final List<String> initialTags;
  
  /// Callback when tags change
  final ValueChanged<List<String>>? onTagsChanged;
  
  /// Optional label
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Maximum number of tags allowed
  final int? maxTags;
  
  /// Whether to allow duplicate tags
  final bool allowDuplicates;
  
  /// Optional tag suggestions
  final List<String>? suggestions;
  
  /// Tag validation function
  final bool Function(String)? validateTag;
  
  /// Text capitalization
  final TextCapitalization textCapitalization;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Padding around the widget
  final EdgeInsetsGeometry? padding;
  
  /// Spacing between chips
  final double chipSpacing;

  const TagInput({
    super.key,
    this.initialTags = const [],
    this.onTagsChanged,
    this.label,
    this.hint = 'Type and press Enter to add tag',
    this.maxTags,
    this.allowDuplicates = false,
    this.suggestions,
    this.validateTag,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    this.padding,
    this.chipSpacing = 8.0,
  });

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  late List<String> _tags;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.suggestions != null) {
      setState(() {
        final query = _controller.text.toLowerCase();
        _filteredSuggestions = widget.suggestions!
            .where((s) => s.toLowerCase().contains(query) && !_tags.contains(s))
            .take(5)
            .toList();
      });
    }
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    
    if (trimmedTag.isEmpty) return;
    
    // Check max tags limit
    if (widget.maxTags != null && _tags.length >= widget.maxTags!) {
      _showSnackBar('Maximum ${widget.maxTags} tags allowed');
      return;
    }
    
    // Check duplicates
    if (!widget.allowDuplicates && _tags.contains(trimmedTag)) {
      _showSnackBar('Tag already exists');
      return;
    }
    
    // Validate tag
    if (widget.validateTag != null && !widget.validateTag!(trimmedTag)) {
      _showSnackBar('Invalid tag');
      return;
    }
    
    setState(() {
      _tags.add(trimmedTag);
      _controller.clear();
      _filteredSuggestions.clear();
    });
    
    widget.onTagsChanged?.call(_tags);
  }

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
    widget.onTagsChanged?.call(_tags);
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          // Input field with chips
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.enabled 
                  ? AppColors.background 
                  : AppColors.border.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _focusNode.hasFocus 
                    ? AppColors.primary 
                    : AppColors.border,
                width: _focusNode.hasFocus ? 2 : 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags display
                if (_tags.isNotEmpty)
                  Wrap(
                    spacing: widget.chipSpacing,
                    runSpacing: widget.chipSpacing,
                    children: _tags.asMap().entries.map((entry) {
                      return chips.TagChip.small(
                        label: entry.value,
                        onDeleted: widget.enabled 
                            ? () => _removeTag(entry.key) 
                            : null,
                      );
                    }).toList(),
                  ),
                
                // Input field
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  textCapitalization: widget.textCapitalization,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(
                      top: _tags.isEmpty ? 0 : 8,
                      bottom: 0,
                    ),
                  ),
                  onSubmitted: widget.enabled ? _addTag : null,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          
          // Suggestions
          if (_filteredSuggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _filteredSuggestions.map((suggestion) {
                  return InkWell(
                    onTap: () => _addTag(suggestion),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.border.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            suggestion,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.add,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          
          // Helper text
          if (widget.maxTags != null) ...[
            const SizedBox(height: 4),
            Text(
              '${_tags.length}/${widget.maxTags} tags',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.text.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple tag selector with predefined options
class TagSelector extends StatefulWidget {
  /// Available tags to select from
  final List<String> availableTags;
  
  /// Initially selected tags
  final List<String> selectedTags;
  
  /// Callback when selection changes
  final ValueChanged<List<String>>? onSelectionChanged;
  
  /// Optional label
  final String? label;
  
  /// Maximum number of tags that can be selected
  final int? maxSelection;
  
  /// Whether to allow multiple selection
  final bool multiSelect;
  
  /// Padding around the widget
  final EdgeInsetsGeometry? padding;

  const TagSelector({
    super.key,
    required this.availableTags,
    this.selectedTags = const [],
    this.onSelectionChanged,
    this.label,
    this.maxSelection,
    this.multiSelect = true,
    this.padding,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        if (!widget.multiSelect) {
          _selectedTags.clear();
        }
        
        if (widget.maxSelection == null || 
            _selectedTags.length < widget.maxSelection!) {
          _selectedTags.add(tag);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Maximum ${widget.maxSelection} tags allowed'),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
      }
    });
    
    widget.onSelectionChanged?.call(_selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return chips.FilterChip(
                label: tag,
                selected: isSelected,
                onSelected: (_) => _toggleTag(tag),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Compact tag list display (read-only)
class TagList extends StatelessWidget {
  /// List of tags to display
  final List<String> tags;
  
  /// Optional callback when tag is tapped
  final ValueChanged<String>? onTagTapped;
  
  /// Chip size
  final chips.TagChipSize size;
  
  /// Maximum number of tags to show
  final int? maxVisible;
  
  /// Spacing between chips
  final double spacing;
  
  /// Padding around the list
  final EdgeInsetsGeometry? padding;

  const TagList({
    super.key,
    required this.tags,
    this.onTagTapped,
    this.size = chips.TagChipSize.small,
    this.maxVisible,
    this.spacing = 6.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final visibleTags = maxVisible != null && tags.length > maxVisible!
        ? tags.take(maxVisible!).toList()
        : tags;
    
    final remainingCount = maxVisible != null && tags.length > maxVisible!
        ? tags.length - maxVisible!
        : 0;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          ...visibleTags.map((tag) {
            return chips.TagChip(
              label: tag,
              size: size,
              onPressed: onTagTapped != null 
                  ? () => onTagTapped!(tag) 
                  : null,
            );
          }),
          if (remainingCount > 0)
            chips.TagChip(
              label: '+$remainingCount',
              size: size,
              backgroundColor: AppColors.border.withOpacity(0.5),
            ),
        ],
      ),
    );
  }
}
