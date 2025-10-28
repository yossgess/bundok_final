import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Message sender type
enum MessageSender {
  user,
  ai,
}

/// Chat message bubble component
/// 
/// Features:
/// - User: right-aligned, bg AppColors.primary, text white
/// - AI: left-aligned, bg AppColors.border, text AppColors.secondary
/// - Rounded corners, max width 80%
/// - Optional timestamp and avatar
/// - Copy message support
class ChatMessageBubble extends StatelessWidget {
  /// Message text
  final String message;
  
  /// Message sender
  final MessageSender sender;
  
  /// Optional timestamp
  final DateTime? timestamp;
  
  /// Whether to show avatar
  final bool showAvatar;
  
  /// Optional avatar widget
  final Widget? avatar;
  
  /// Whether message is being sent
  final bool isSending;
  
  /// Whether message failed to send
  final bool hasFailed;
  
  /// Callback when retry is pressed (for failed messages)
  final VoidCallback? onRetry;
  
  /// Maximum width percentage (0.0 to 1.0)
  final double maxWidthFactor;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.sender,
    this.timestamp,
    this.showAvatar = true,
    this.avatar,
    this.isSending = false,
    this.hasFailed = false,
    this.onRetry,
    this.maxWidthFactor = 0.8,
  });

  /// User message bubble
  const ChatMessageBubble.user({
    super.key,
    required this.message,
    this.timestamp,
    this.showAvatar = false,
    this.avatar,
    this.isSending = false,
    this.hasFailed = false,
    this.onRetry,
    this.maxWidthFactor = 0.8,
  }) : sender = MessageSender.user;

  /// AI message bubble
  const ChatMessageBubble.ai({
    super.key,
    required this.message,
    this.timestamp,
    this.showAvatar = true,
    this.avatar,
    this.isSending = false,
    this.hasFailed = false,
    this.onRetry,
    this.maxWidthFactor = 0.8,
  }) : sender = MessageSender.ai;

  @override
  Widget build(BuildContext context) {
    final isUser = sender == MessageSender.user;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * maxWidthFactor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI avatar (left side)
          if (!isUser && showAvatar) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          
          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: isUser 
                    ? CrossAxisAlignment.end 
                    : CrossAxisAlignment.start,
                children: [
                  // Message content
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isUser 
                          ? AppColors.primary 
                          : AppColors.border,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 15,
                            color: isUser 
                                ? Colors.white 
                                : AppColors.secondary,
                            height: 1.4,
                          ),
                        ),
                        
                        // Sending/Failed indicator
                        if (isSending || hasFailed) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSending)
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isUser 
                                          ? Colors.white.withOpacity(0.7) 
                                          : AppColors.secondary.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              if (hasFailed) ...[
                                Icon(
                                  Icons.error_outline,
                                  size: 14,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: onRetry,
                                  child: Text(
                                    'Retry',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Timestamp
                  if (timestamp != null) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        _formatTimestamp(timestamp!),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.text.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // User avatar (right side)
          if (isUser && showAvatar) ...[
            const SizedBox(width: 8),
            _buildAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (avatar != null) return avatar!;
    
    final isUser = sender == MessageSender.user;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser 
            ? AppColors.primary.withOpacity(0.2) 
            : AppColors.accent.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        size: 18,
        color: isUser ? AppColors.primary : AppColors.accent,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// Chat message with actions (copy, delete, etc.)
class ChatMessageBubbleWithActions extends StatefulWidget {
  /// Message text
  final String message;
  
  /// Message sender
  final MessageSender sender;
  
  /// Optional timestamp
  final DateTime? timestamp;
  
  /// Whether to show avatar
  final bool showAvatar;
  
  /// Callback when copy is pressed
  final VoidCallback? onCopy;
  
  /// Callback when delete is pressed
  final VoidCallback? onDelete;
  
  /// Optional additional actions
  final List<MessageAction>? actions;

  const ChatMessageBubbleWithActions({
    super.key,
    required this.message,
    required this.sender,
    this.timestamp,
    this.showAvatar = true,
    this.onCopy,
    this.onDelete,
    this.actions,
  });

  @override
  State<ChatMessageBubbleWithActions> createState() => 
      _ChatMessageBubbleWithActionsState();
}

class _ChatMessageBubbleWithActionsState 
    extends State<ChatMessageBubbleWithActions> {
  bool _showActions = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _showActions = !_showActions;
        });
      },
      child: Column(
        children: [
          ChatMessageBubble(
            message: widget.message,
            sender: widget.sender,
            timestamp: widget.timestamp,
            showAvatar: widget.showAvatar,
          ),
          
          // Actions
          if (_showActions)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: widget.sender == MessageSender.user
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (widget.onCopy != null)
                    _ActionButton(
                      icon: Icons.copy,
                      label: 'Copy',
                      onPressed: widget.onCopy,
                    ),
                  if (widget.onDelete != null) ...[
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      onPressed: widget.onDelete,
                    ),
                  ],
                  if (widget.actions != null)
                    ...widget.actions!.map((action) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _ActionButton(
                          icon: action.icon,
                          label: action.label,
                          onPressed: action.onPressed,
                        ),
                      );
                    }),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.border.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.secondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Message action data model
class MessageAction {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const MessageAction({
    required this.icon,
    required this.label,
    this.onPressed,
  });
}

/// Typing indicator bubble
class TypingIndicatorBubble extends StatefulWidget {
  /// Whether to show avatar
  final bool showAvatar;

  const TypingIndicatorBubble({
    super.key,
    this.showAvatar = true,
  });

  @override
  State<TypingIndicatorBubble> createState() => _TypingIndicatorBubbleState();
}

class _TypingIndicatorBubbleState extends State<TypingIndicatorBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.showAvatar) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 18,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    final value = (_controller.value - delay) % 1.0;
                    final opacity = (value < 0.5 ? value * 2 : (1 - value) * 2)
                        .clamp(0.3, 1.0);
                    
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < 2 ? 4 : 0,
                      ),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(opacity),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Date separator for chat messages
class ChatDateSeparator extends StatelessWidget {
  /// Date to display
  final DateTime date;

  const ChatDateSeparator({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: AppColors.border,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.text.withOpacity(0.6),
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              color: AppColors.border,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
