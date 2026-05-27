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
    final name = _resolve(clientName, _fallbackName);
    final nameLatin = clientNameLatin?.trim();
    final cycleVal = _resolve(cycle, '1');
    final phone = _resolve(mobile, _fallbackPhone);
    final days = _resolve(overdueDays, _fallbackOverdueDays);
    final location = _resolve(villageName, _fallbackLocation);
    final disbAmount = _resolve(disbursementAmount, _fallbackAmount);
    final payAmount = _resolve(bottomAmount, _fallbackAmount);
    final payLabel = _resolve(bottomLabel, _fallbackLabel);

    return InkWell(
      onTap: onTap,
      borderRadius: UIConstants.radius.radiusAll,
      child: Container(
        decoration: BoxDecoration(
          // color: AppColor.white,
          borderRadius: UIConstants.radius.radiusAll,
          border: Border.all(width: 1, color: AppColor.lightred),
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
                      // Name + cycle inline
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              nameLatin != null && nameLatin.isNotEmpty
                                  ? '$name  -  $nameLatin'
                                  : name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF171617),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(វដ្គទី $cycleVal)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColor.pinkRed,
                            ),
                          ),
                        ],
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

            // ── Bottom: loan amount (2 lines) + pay pill ──
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image.asset(
                          //   'assets/images/icon/amountLoans.png',
                          //   width: 16,
                          //   height: 16,
                          // ),
                          // const SizedBox(width: 6),
                          Text(
                            'ប្រាក់កម្ចី',
                            style: AppTextStyle.smallPrimaryRegular,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatCurrency(disbAmount),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF171617),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onBottomActionTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.hardOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$payLabel ៖ ${_formatCurrency(payAmount)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
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
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: AppColor.secondPrime, width: 2.5),
      ),
      padding: const EdgeInsets.all(5), // white gap between rings
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: AppColor.secondPrime, width: 12),
        ),
        child: Icon(Icons.done, color: AppColor.secondPrime, size: 18),
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
        Icon(icon, size: 14, color: AppColor.secondPrime),
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
