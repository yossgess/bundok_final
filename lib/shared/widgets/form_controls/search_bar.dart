import 'package:flutter/material.dart' hide SearchBar;
import '../../../core/constants/app_colors.dart';

/// Custom search bar component
/// 
/// Features:
/// - Rounded input with search icon + clear button
/// - Localized placeholder
/// - Debounced search support
/// - Optional filter button
/// - Voice search support (optional)
class SearchBar extends StatefulWidget {
  /// Search query controller
  final TextEditingController? controller;
  
  /// Callback when search query changes
  final ValueChanged<String>? onChanged;
  
  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Placeholder text
  final String? hint;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  /// Whether to show filter button
  final bool showFilterButton;
  
  /// Callback when filter button is pressed
  final VoidCallback? onFilterPressed;
  
  /// Whether to show voice search button
  final bool showVoiceSearch;
  
  /// Callback when voice search is pressed
  final VoidCallback? onVoiceSearchPressed;
  
  /// Whether search bar is enabled
  final bool enabled;
  
  /// Whether to auto-focus on mount
  final bool autofocus;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Border radius
  final double borderRadius;
  
  /// Padding inside the search bar
  final EdgeInsetsGeometry? contentPadding;
  
  /// Margin around the search bar
  final EdgeInsetsGeometry? margin;
  
  /// Elevation (shadow depth)
  final double elevation;

  const SearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hint,
    this.showClearButton = true,
    this.showFilterButton = false,
    this.onFilterPressed,
    this.showVoiceSearch = false,
    this.onVoiceSearchPressed,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.backgroundColor,
    this.borderRadius = 24.0,
    this.contentPadding,
    this.margin,
    this.elevation = 0,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.background,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
        ),
        boxShadow: widget.elevation > 0
            ? [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.08),
                  blurRadius: widget.elevation * 2,
                  offset: Offset(0, widget.elevation),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Search icon
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              Icons.search,
              color: AppColors.text.withOpacity(0.5),
              size: 20,
            ),
          ),
          
          // Text input
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Search...',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: AppColors.text.withOpacity(0.5),
                ),
                border: InputBorder.none,
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          // Clear button
          if (widget.showClearButton && _controller.text.isNotEmpty)
            IconButton(
              onPressed: _clearSearch,
              icon: const Icon(Icons.clear, size: 18),
              color: AppColors.text.withOpacity(0.5),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          
          // Voice search button
          if (widget.showVoiceSearch)
            IconButton(
              onPressed: widget.onVoiceSearchPressed,
              icon: const Icon(Icons.mic, size: 20),
              color: AppColors.primary,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          
          // Filter button
          if (widget.showFilterButton)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: widget.onFilterPressed,
                icon: const Icon(Icons.filter_list, size: 20),
                color: AppColors.secondary,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ),
          
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// Compact search field (smaller, inline variant)
class CompactSearchField extends StatelessWidget {
  /// Search query controller
  final TextEditingController? controller;
  
  /// Callback when search query changes
  final ValueChanged<String>? onChanged;
  
  /// Placeholder text
  final String? hint;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  /// Whether field is enabled
  final bool enabled;

  const CompactSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hint,
    this.showClearButton = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      onChanged: onChanged,
      hint: hint,
      showClearButton: showClearButton,
      enabled: enabled,
      borderRadius: 8,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.zero,
    );
  }
}

/// Search bar with suggestions dropdown
class SearchBarWithSuggestions extends StatefulWidget {
  /// Search query controller
  final TextEditingController? controller;
  
  /// Callback when search query changes
  final ValueChanged<String>? onChanged;
  
  /// Callback to get suggestions based on query
  final Future<List<String>> Function(String)? onGetSuggestions;
  
  /// Callback when suggestion is selected
  final ValueChanged<String>? onSuggestionSelected;
  
  /// Placeholder text
  final String? hint;
  
  /// Maximum number of suggestions to show
  final int maxSuggestions;

  const SearchBarWithSuggestions({
    super.key,
    this.controller,
    this.onChanged,
    this.onGetSuggestions,
    this.onSuggestionSelected,
    this.hint,
    this.maxSuggestions = 5,
  });

  @override
  State<SearchBarWithSuggestions> createState() =>
      _SearchBarWithSuggestionsState();
}

class _SearchBarWithSuggestionsState extends State<SearchBarWithSuggestions> {
  late TextEditingController _controller;
  List<String> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _onTextChanged() async {
    final query = _controller.text;
    
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }
    
    if (widget.onGetSuggestions != null) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final suggestions = await widget.onGetSuggestions!(query);
        setState(() {
          _suggestions = suggestions.take(widget.maxSuggestions).toList();
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    
    widget.onChanged?.call(query);
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    setState(() {
      _suggestions = [];
    });
    widget.onSuggestionSelected?.call(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          controller: _controller,
          hint: widget.hint,
        ),
        
        // Suggestions dropdown
        if (_suggestions.isNotEmpty || _isLoading)
          Container(
            margin: const EdgeInsets.only(top: 8),
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
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      thickness: 0.5,
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.search,
                          size: 18,
                          color: AppColors.text,
                        ),
                        title: Text(
                          suggestion,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                          ),
                        ),
                        onTap: () => _selectSuggestion(suggestion),
                      );
                    },
                  ),
          ),
      ],
    );
  }
}

/// Search bar with recent searches
class SearchBarWithHistory extends StatefulWidget {
  /// Search query controller
  final TextEditingController? controller;
  
  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// List of recent searches
  final List<String> recentSearches;
  
  /// Callback when recent search is cleared
  final ValueChanged<String>? onClearRecent;
  
  /// Placeholder text
  final String? hint;
  
  /// Maximum recent searches to show
  final int maxRecent;

  const SearchBarWithHistory({
    super.key,
    this.controller,
    this.onSubmitted,
    this.recentSearches = const [],
    this.onClearRecent,
    this.hint,
    this.maxRecent = 5,
  });

  @override
  State<SearchBarWithHistory> createState() => _SearchBarWithHistoryState();
}

class _SearchBarWithHistoryState extends State<SearchBarWithHistory> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showHistory = _focusNode.hasFocus && _controller.text.isEmpty;
    });
  }

  void _selectRecent(String query) {
    _controller.text = query;
    widget.onSubmitted?.call(query);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final recentToShow = widget.recentSearches.take(widget.maxRecent).toList();

    return Column(
      children: [
        SearchBar(
          controller: _controller,
          focusNode: _focusNode,
          hint: widget.hint,
          onSubmitted: widget.onSubmitted,
          onChanged: (value) {
            setState(() {
              _showHistory = value.isEmpty && _focusNode.hasFocus;
            });
          },
        ),
        
        // Recent searches
        if (_showHistory && recentToShow.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text.withOpacity(0.6),
                    ),
                  ),
                ),
                ...recentToShow.map((query) {
                  return ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.history,
                      size: 18,
                      color: AppColors.text,
                    ),
                    title: Text(
                      query,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () => widget.onClearRecent?.call(query),
                      color: AppColors.text.withOpacity(0.5),
                    ),
                    onTap: () => _selectRecent(query),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}
