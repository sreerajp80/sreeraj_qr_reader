import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';
import 'package:sreeraj_qr_reader/services/payload_action_service.dart';

class PaymentActionCard extends StatelessWidget {
  final PaymentPayload payload;

  const PaymentActionCard({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final payment = payload;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final schemeName = payment.scheme == PaymentScheme.upi
        ? 'UPI Payment'
        : payment.scheme == PaymentScheme.sepa
        ? 'SEPA Transfer'
        : 'Crypto Payment';

    final schemeColor = payment.scheme == PaymentScheme.upi
        ? Colors.teal
        : payment.scheme == PaymentScheme.sepa
        ? Colors.indigo
        : Colors.amber[800]!;

    final containerBg = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : Colors.grey[100];

    final borderColor = isDark
        ? theme.colorScheme.outline.withValues(alpha: 0.3)
        : Colors.grey[300]!;

    final textColor = isDark ? theme.colorScheme.onSurface : Colors.black87;

    final labelColor = isDark
        ? theme.colorScheme.onSurfaceVariant
        : Colors.grey[600];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: schemeColor, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: schemeColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    payment.scheme == PaymentScheme.crypto
                        ? Icons.currency_bitcoin
                        : Icons.account_balance_wallet,
                    color: schemeColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schemeName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: schemeColor,
                        ),
                      ),
                      Text(
                        payment.payeeName.isNotEmpty
                            ? payment.payeeName
                            : 'Merchant / Payee',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (payment.amount.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: schemeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${payment.currency} ${payment.amount}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // Payee Address / VPA / IBAN / Wallet
            if (payment.payeeAddress.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: containerBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          payment.scheme == PaymentScheme.upi
                              ? 'VPA / UPI ID:'
                              : payment.scheme == PaymentScheme.sepa
                              ? 'IBAN:'
                              : 'Wallet Address:',
                          style: TextStyle(fontSize: 11, color: labelColor),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: payment.payeeAddress),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  payment.scheme == PaymentScheme.upi
                                      ? 'UPI ID copied to clipboard'
                                      : 'Address copied to clipboard',
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.copy, size: 14, color: schemeColor),
                              const SizedBox(width: 4),
                              Text(
                                'Copy',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: schemeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      payment.payeeAddress,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Note / Ref
            if (payment.transactionNote.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.notes, size: 16, color: labelColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Note: ${payment.transactionNote}',
                      style: TextStyle(fontSize: 12, color: labelColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],

            const SizedBox(height: 6),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: Text(
                  payment.scheme == PaymentScheme.upi
                      ? 'Pay via App (GPay / PhonePe / Paytm)'
                      : 'Pay via App',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: schemeColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final launched = await PayloadActionService.payViaApp(
                    payment,
                  );
                  if (!launched && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          payment.scheme == PaymentScheme.upi
                              ? 'Could not open UPI app. Make sure GPay, PhonePe, or Paytm is installed.'
                              : 'Could not open payment app for this scheme.',
                        ),
                        action: payment.payeeAddress.isNotEmpty
                            ? SnackBarAction(
                                label: 'Copy ID',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: payment.payeeAddress),
                                  );
                                },
                              )
                            : null,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
