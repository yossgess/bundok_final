import 'package:flutter/material.dart';
// TODO: Add url_launcher to pubspec.yaml: url_launcher: ^6.2.0
// import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import 'base_modal.dart';

/// Email export modal component
/// 
/// Features:
/// - Form: email input + "Send" button
/// - Uses url_launcher or system share
/// - Email validation
/// - Multiple recipients support
/// - Optional subject and body
class EmailExportModal extends StatefulWidget {
  /// Modal title
  final String title;
  
  /// Export description
  final String? description;
  
  /// Default email subject
  final String? defaultSubject;
  
  /// Default email body
  final String? defaultBody;
  
  /// File name being exported
  final String? fileName;
  
  /// Callback when email is sent
  final ValueChanged<String>? onSend;
  
  /// Whether to allow multiple recipients
  final bool allowMultipleRecipients;

  const EmailExportModal({
    super.key,
    this.title = 'Export via Email',
    this.description,
    this.defaultSubject,
    this.defaultBody,
    this.fileName,
    this.onSend,
    this.allowMultipleRecipients = false,
  });

  /// Invoice export modal
  factory EmailExportModal.invoice({
    String? invoiceNumber,
    ValueChanged<String>? onSend,
  }) {
    return EmailExportModal(
      title: 'Email Invoice',
      description: 'Send invoice ${invoiceNumber ?? ""} via email',
      defaultSubject: 'Invoice ${invoiceNumber ?? ""}',
      defaultBody: 'Please find the attached invoice.',
      fileName: 'invoice_${invoiceNumber ?? ""}.pdf',
      onSend: onSend,
    );
  }

  /// Report export modal
  factory EmailExportModal.report({
    String? reportName,
    ValueChanged<String>? onSend,
  }) {
    return EmailExportModal(
      title: 'Email Report',
      description: 'Send ${reportName ?? "report"} via email',
      defaultSubject: reportName ?? 'Report',
      defaultBody: 'Please find the attached report.',
      fileName: '${reportName?.toLowerCase().replaceAll(' ', '_') ?? "report"}.pdf',
      onSend: onSend,
    );
  }

  @override
  State<EmailExportModal> createState() => _EmailExportModalState();
}

class _EmailExportModalState extends State<EmailExportModal> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSending = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      // final subject = Uri.encodeComponent(widget.defaultSubject ?? '');
      // final body = Uri.encodeComponent(widget.defaultBody ?? '');
      
      // TODO: Add url_launcher to pubspec.yaml: url_launcher: ^6.2.0
      // final emailUri = Uri(
      //   scheme: 'mailto',
      //   path: email,
      //   query: 'subject=$subject&body=$body',
      // );

      // TODO: Uncomment when url_launcher is added
      // if (await canLaunchUrl(emailUri)) {
      //   await launchUrl(emailUri);
      //   if (mounted) {
      //     Navigator.of(context).pop(true);
      //     widget.onSend?.call(email);
      //   }
      // } else {
      //   setState(() {
      //     _errorMessage = 'Could not open email app';
      //   });
      // }
      
      // Temporary: Just close and call callback
      if (mounted) {
        Navigator.of(context).pop(true);
        widget.onSend?.call(email);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send email: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: widget.title,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Description
            if (widget.description != null) ...[
              Text(
                widget.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.text.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // File name
            if (widget.fileName != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.border.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_file,
                      size: 20,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.fileName!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Email input
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              enabled: !_isSending,
              validator: _validateEmail,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter recipient email',
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
            
            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 20,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: _isSending ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        
        // Send button
        ElevatedButton(
          onPressed: _isSending ? null : _sendEmail,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: _isSending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Send'),
        ),
      ],
    );
  }

  /// Show email export modal
  static Future<bool?> show({
    required BuildContext context,
    String title = 'Export via Email',
    String? description,
    String? defaultSubject,
    String? defaultBody,
    String? fileName,
    ValueChanged<String>? onSend,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EmailExportModal(
          title: title,
          description: description,
          defaultSubject: defaultSubject,
          defaultBody: defaultBody,
          fileName: fileName,
          onSend: onSend,
        ),
      ),
    );
  }
}

/// Share options modal
class ShareOptionsModal extends StatelessWidget {
  /// Item being shared
  final String itemName;
  
  /// Share options
  final List<ShareOption> options;

  const ShareOptionsModal({
    super.key,
    required this.itemName,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: 'Share $itemName',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pop();
              option.onPressed?.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: option.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      option.icon,
                      size: 24,
                      color: option.color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary,
                          ),
                        ),
                        if (option.description != null)
                          Text(
                            option.description!,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.text.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Show share options modal
  static Future<void> show({
    required BuildContext context,
    required String itemName,
    required List<ShareOption> options,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareOptionsModal(
        itemName: itemName,
        options: options,
      ),
    );
  }

  /// Default share options for invoices
  static List<ShareOption> invoiceOptions({
    VoidCallback? onEmail,
    VoidCallback? onPDF,
    VoidCallback? onPrint,
    VoidCallback? onShare,
  }) {
    return [
      ShareOption(
        icon: Icons.email_outlined,
        label: 'Email',
        description: 'Send via email',
        color: AppColors.primary,
        onPressed: onEmail,
      ),
      ShareOption(
        icon: Icons.picture_as_pdf,
        label: 'Export as PDF',
        description: 'Save to device',
        color: AppColors.error,
        onPressed: onPDF,
      ),
      ShareOption(
        icon: Icons.print,
        label: 'Print',
        description: 'Print document',
        color: AppColors.secondary,
        onPressed: onPrint,
      ),
      ShareOption(
        icon: Icons.share,
        label: 'Share',
        description: 'Share via other apps',
        color: AppColors.accent,
        onPressed: onShare,
      ),
    ];
  }
}

/// Share option data model
class ShareOption {
  final IconData icon;
  final String label;
  final String? description;
  final Color color;
  final VoidCallback? onPressed;

  const ShareOption({
    required this.icon,
    required this.label,
    this.description,
    required this.color,
    this.onPressed,
  });
}
