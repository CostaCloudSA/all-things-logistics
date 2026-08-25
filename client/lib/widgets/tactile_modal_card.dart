import 'package:flutter/material.dart';

/// Metric item for the $2\times 2$ tactile follow-up grid
class TactileMetricItem {
  final String label;
  final String value;
  final Color? valueColor;
  final String? badgeText;
  final Color? badgeColor;

  const TactileMetricItem({
    required this.label,
    required this.value,
    this.valueColor,
    this.badgeText,
    this.badgeColor,
  });
}

/// Unified Tactile Macro Detail Modal Card
/// Consistent with the high-contrast 2x4 macro grid design language
class TactileModalCard extends StatefulWidget {
  final String companyName;
  final Color brandColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final List<TactileMetricItem> metrics;
  final String actionButtonText;
  final IconData actionButtonIcon;
  final String successMessage;
  final String ed25519Signature;
  final String? secondaryNote;
  final VoidCallback? onActionCompleted;

  const TactileModalCard({
    Key? key,
    required this.companyName,
    required this.brandColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.metrics,
    required this.actionButtonText,
    required this.actionButtonIcon,
    required this.successMessage,
    required this.ed25519Signature,
    this.secondaryNote,
    this.onActionCompleted,
  }) : super(key: key);

  @override
  State<TactileModalCard> createState() => _TactileModalCardState();
}

class _TactileModalCardState extends State<TactileModalCard> {
  bool _isProcessing = false;
  bool _isSuccess = false;

  void _handleAction() async {
    setState(() {
      _isProcessing = true;
    });
    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _isSuccess = true;
    });
    if (widget.onActionCompleted != null) {
      widget.onActionCompleted!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Slate 900
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF475569),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Company Context Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.brandColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: widget.brandColor.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: widget.brandColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.companyName.toUpperCase(),
                      style: TextStyle(
                        color: widget.brandColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Hero Icon & Title Header
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: widget.brandColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: widget.brandColor.withOpacity(0.35), width: 1.5),
                ),
                child: Icon(widget.icon, color: widget.brandColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Simplified 2x2 Key Metric Mini-Grid
          if (widget.metrics.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
              ),
              itemCount: widget.metrics.length,
              itemBuilder: (context, index) {
                final metric = widget.metrics[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            metric.label.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (metric.badgeText != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: (metric.badgeColor ?? const Color(0xFF10B981)).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                metric.badgeText!,
                                style: TextStyle(
                                  color: metric.badgeColor ?? const Color(0xFF10B981),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        metric.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: metric.valueColor ?? Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 16),

          // Success Message Banner if completed
          if (_isSuccess)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF065F46).withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF10B981)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.successMessage,
                      style: const TextStyle(
                        color: Color(0xFF6EE7B7),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // 1-Tap Bold Primary Action Button
          ElevatedButton(
            onPressed: (_isProcessing || _isSuccess) ? null : _handleAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.brandColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 4,
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isSuccess ? Icons.verified : widget.actionButtonIcon, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isSuccess ? 'PROCESSED & SEALED' : widget.actionButtonText,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),

          // Secondary Note if present
          if (widget.secondaryNote != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.secondaryNote!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // Ed25519 Cryptographic Seal Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1120),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 12, color: Color(0xFF10B981)),
                const SizedBox(width: 6),
                Text(
                  'Ed25519 Seal: ${widget.ed25519Signature}',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
