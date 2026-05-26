import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';

class LoanClientCard extends StatelessWidget {
  const LoanClientCard({
    Key? key,
    this.clientName,
    this.clientNameLatin,
    this.cycle,
    this.mobile,
    this.overdueDays,
    this.villageName,
    this.lastPaymentDate,
    this.disbursementAmount,
    this.bottomAmount,
    this.bottomLabel,
    required this.onTap,
    this.onPrint,
    this.onBottomActionTap,
  }) : super(key: key);

  final String? clientName;
  final String? clientNameLatin;
  final String? cycle;
  final String? mobile;
  final String? overdueDays;
  final String? villageName;
  final String? lastPaymentDate;
  final String? disbursementAmount;
  final String? bottomLabel;
  final String? bottomAmount;
  final VoidCallback onTap;
  final VoidCallback? onPrint;
  final VoidCallback? onBottomActionTap;

  // ── Static fallbacks — shown when data is missing ──
  static const String _fallbackName = 'មិនមានឈ្មោះ'; // No name
  static const String _fallbackPhone = 'មិនមានលេខ'; // No phone
  static const String _fallbackLocation = 'មិនមានទីតាំង'; // No location
  static const String _fallbackOverdueDays = '0';
  static const String _fallbackDate = '---';
  static const String _fallbackAmount = '0';
  static const String _fallbackLabel = 'ប្រាក់ត្រូវបង់';

  // ── Resolves value — uses fallback if null, empty, or literally 'N/A' ──
  String _resolve(String? value, String fallback) {
    if (value == null || value.trim().isEmpty || value.trim() == 'N/A') {
      return fallback;
    }
    return value.trim();
  }

  @override
  Widget build(BuildContext context) {
    // Resolve all fields once at the top
    final name = _resolve(clientName, _fallbackName);
    final nameLatin = clientNameLatin?.trim();
    final cycleVal = _resolve(cycle, '1');
    final phone = _resolve(mobile, _fallbackPhone);
    final days = _resolve(overdueDays, _fallbackOverdueDays);
    final location = _resolve(villageName, _fallbackLocation);
    final disbAmount = _resolve(disbursementAmount, _fallbackAmount);
    final payAmount = _resolve(bottomAmount, _fallbackAmount);
    final payLabel = _resolve(bottomLabel, _fallbackLabel);

    final displayName =
        (nameLatin != null && nameLatin.isNotEmpty)
            ? '$name  -  $nameLatin'
            : name;

    return InkWell(
      onTap: onTap,
      borderRadius: UIConstants.radius.radiusAll,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: UIConstants.radius.radiusAll,
          border: Border.all(width: 1, color: AppColor.lightGrey),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top: avatar + name + print ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAvatar(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF171617),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInfoRow(phone, location, days),
                    ],
                  ),
                ),
                if (onPrint != null) _buildPrintButton(),
              ],
            ),

            const SizedBox(height: 12),
            const DarkGreyDivider(),
            const SizedBox(height: 10),

            // ── Bottom: loan amount + pay pill ──
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💰', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      'ប្រាក់កម្ចី ៖ ${_formatCurrency(disbAmount)}',
                      style: AppTextStyle.smallPrimaryRegular,
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onBottomActionTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$payLabel ៖ ${_formatCurrency(payAmount)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColor.red,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildInfoRow(String phone, String location, String days) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _iconText(Icons.phone, phone),
        _separator(),
        _iconText(Icons.location_on, location),
        _separator(),
        _iconText(Icons.access_time, 'Late by $days day'),
      ],
    );
  }

  Widget _iconText(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColor.red),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _separator() {
    return const Text('|', style: TextStyle(color: Colors.grey, fontSize: 12));
  }

  Widget _buildPrintButton() {
    return OutlinedButton.icon(
      onPressed: onPrint,
      icon: const Icon(Icons.print, size: 16),
      label: const Text('Print'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey,
        side: const BorderSide(color: Color(0xFFD3D3D3)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        textStyle: const TextStyle(fontSize: 13),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  String _formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }
}
