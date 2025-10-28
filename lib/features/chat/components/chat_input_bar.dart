import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Chat input bar component
/// 
/// Features:
/// - Text input + send button
/// - Auto-expands with multiline support
/// - Optional attachment button
/// - Optional voice input button
/// - Character counter support
class ChatInputBar extends StatefulWidget {
  /// Text editing controller
  final TextEditingController? controller;
  
  /// Callback when message is sent
  final ValueChanged<String>? onSend;
  
  /// Hint text
  final String? hint;
  
  /// Maximum number of lines
  final int maxLines;
  
  /// Minimum number of lines
  final int minLines;
  
  /// Maximum message length
  final int? maxLength;
  
  /// Whether to show character counter
  final bool showCounter;
  
  /// Whether to show attachment button
  final bool showAttachment;
  
  /// Callback when attachment is pressed
  final VoidCallback? onAttachment;
  
  /// Whether to show voice input button
  final bool showVoiceInput;
  
  /// Callback when voice input is pressed
  final VoidCallback? onVoiceInput;
  
  /// Whether input is enabled
  final bool enabled;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Border color
  final Color? borderColor;

  const ChatInputBar({
    super.key,
    this.controller,
    this.onSend,
    this.hint = 'Type a message...',
    this.maxLines = 5,
    this.minLines = 1,
    this.maxLength,
    this.showCounter = false,
    this.showAttachment = false,
    this.onAttachment,
    this.showVoiceInput = false,
    this.onVoiceInput,
    this.enabled = true,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late TextEditingController _controller;
  bool _hasText = false;

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

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.onSend != null) {
      widget.onSend!(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = widget.backgroundColor ?? 
        AppColors.background;
    final effectiveBorderColor = widget.borderColor ?? AppColors.border;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: Border(
          top: BorderSide(
            color: effectiveBorderColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attachment button
              if (widget.showAttachment)
                IconButton(
                  onPressed: widget.enabled ? widget.onAttachment : null,
                  icon: const Icon(Icons.attach_file),
                  color: AppColors.secondary,
                  padding: const EdgeInsets.all(8),
                ),
              
              // Text input
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: widget.maxLines * 24.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.border.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          enabled: widget.enabled,
                          maxLines: widget.maxLines,
                          minLines: widget.minLines,
                          maxLength: widget.maxLength,
                          textCapitalization: TextCapitalization.sentences,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.text,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hint,
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: AppColors.text.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            counterText: widget.showCounter ? null : '',
                          ),
                        ),
                      ),
                      
                      // Voice input button (when no text)
                      if (widget.showVoiceInput && !_hasText)
                        Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                          child: InkWell(
                            onTap: widget.enabled ? widget.onVoiceInput : null,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.mic,
                                size: 20,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Send button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: InkWell(
                  onTap: _hasText && widget.enabled ? _handleSend : null,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _hasText && widget.enabled
                          ? AppColors.primary
                          : AppColors.border.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      size: 20,
                      color: _hasText && widget.enabled
                          ? Colors.white
                          : AppColors.text.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact chat input bar (minimal design)
class CompactChatInputBar extends StatelessWidget {
  /// Text editing controller
  final TextEditingController? controller;
  
  /// Callback when message is sent
  final ValueChanged<String>? onSend;
  
  /// Hint text
  final String? hint;
  
  /// Whether input is enabled
  final bool enabled;

  const CompactChatInputBar({
    super.key,
    this.controller,
    this.onSend,
    this.hint = 'Type a message...',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ChatInputBar(
      controller: controller,
      onSend: onSend,
      hint: hint,
      enabled: enabled,
      maxLines: 1,
      showAttachment: false,
      showVoiceInput: false,
    );
  }
}

/// Chat input bar with reply preview
class ChatInputBarWithReply extends StatelessWidget {
  /// Text editing controller
  final TextEditingController? controller;
  
  /// Callback when message is sent
  final ValueChanged<String>? onSend;
  
  /// Message being replied to
  final String? replyToMessage;
  
  /// Sender of message being replied to
  final String? replyToSender;
  
  /// Callback when reply is cancelled
  final VoidCallback? onCancelReply;
  
  /// Hint text
  final String? hint;
  
  /// Whether input is enabled
  final bool enabled;

  const ChatInputBarWithReply({
    super.key,
    this.controller,
    this.onSend,
    this.replyToMessage,
    this.replyToSender,
    this.onCancelReply,
    this.hint = 'Type a message...',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Reply preview
        if (replyToMessage != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.border,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Replying to ${replyToSender ?? "message"}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        replyToMessage!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.text.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onCancelReply,
                  icon: const Icon(Icons.close, size: 18),
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
        
        // Input bar
        ChatInputBar(
          controller: controller,
          onSend: onSend,
          hint: hint,
          enabled: enabled,
        ),
      ],
    );
  }
}

/// Chat input bar with typing indicator
class ChatInputBarWithTyping extends StatefulWidget {
  /// Text editing controller
  final TextEditingController? controller;
  
  /// Callback when message is sent
  final ValueChanged<String>? onSend;
  
  /// Callback when typing status changes
  final ValueChanged<bool>? onTypingChanged;
  
  /// Hint text
  final String? hint;
  
  /// Whether input is enabled
  final bool enabled;

  const ChatInputBarWithTyping({
    super.key,
    this.controller,
    this.onSend,
    this.onTypingChanged,
    this.hint = 'Type a message...',
    this.enabled = true,
  });

  @override
  State<ChatInputBarWithTyping> createState() => 
      _ChatInputBarWithTypingState();
}

class _ChatInputBarWithTypingState extends State<ChatInputBarWithTyping> {
  late TextEditingController _controller;
  bool _isTyping = false;

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

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _isTyping) {
      setState(() {
        _isTyping = hasText;
      });
      widget.onTypingChanged?.call(hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatInputBar(
      controller: _controller,
      onSend: widget.onSend,
      hint: widget.hint,
      enabled: widget.enabled,
    );
  }
}

/// Chat input bar with emoji picker
class ChatInputBarWithEmoji extends StatefulWidget {
  /// Text editing controller
  final TextEditingController? controller;
  
  /// Callback when message is sent
  final ValueChanged<String>? onSend;
  
  /// Hint text
  final String? hint;
  
  /// Whether input is enabled
  final bool enabled;

  const ChatInputBarWithEmoji({
    super.key,
    this.controller,
    this.onSend,
    this.hint = 'Type a message...',
    this.enabled = true,
  });

  @override
  State<ChatInputBarWithEmoji> createState() => _ChatInputBarWithEmojiState();
}

class _ChatInputBarWithEmojiState extends State<ChatInputBarWithEmoji> {
  bool _showEmojiPicker = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emoji picker placeholder
        if (_showEmojiPicker)
          Container(
            height: 250,
            color: AppColors.background,
            child: Center(
              child: Text(
                'Emoji Picker\n(Integrate emoji_picker_flutter package)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.text.withOpacity(0.6),
                ),
              ),
            ),
          ),
        
        // Input bar with emoji button
        Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(
              top: BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Emoji button
                  IconButton(
                    onPressed: widget.enabled
                        ? () => setState(() => _showEmojiPicker = !_showEmojiPicker)
                        : null,
                    icon: Icon(
                      _showEmojiPicker 
                          ? Icons.keyboard 
                          : Icons.emoji_emotions_outlined,
                    ),
                    color: AppColors.secondary,
                  ),
                  
                  // Text input
                  Expanded(
                    child: ChatInputBar(
                      controller: widget.controller,
                      onSend: widget.onSend,
                      hint: widget.hint,
                      enabled: widget.enabled,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
