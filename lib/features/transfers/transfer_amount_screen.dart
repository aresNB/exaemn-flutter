import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/wallet.dart';
import 'transfer_confirmation_screen.dart';

class TransferAmountScreen extends StatefulWidget {
  final Wallet recipientWallet;

  const TransferAmountScreen({super.key, required this.recipientWallet});

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  String _amount = '';

  void _onKeyTap(String value) {
    setState(() {
      if (value == 'back') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
      } else {
        // Empêche plusieurs zéros au début et limite la longueur
        if (_amount == '0' && value == '0') return;
        if (_amount.length < 9) {
          _amount += value;
        }
      }
    });
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyTap(value),
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Center(
            child: value == 'back'
                ? const Icon(
                    Icons.backspace_outlined,
                    color: AppColors.white,
                    size: 22,
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyRow(List<String> values) {
    return Row(children: values.map(_buildKey).toList());
  }

  @override
  Widget build(BuildContext context) {
    final double amountValue = double.tryParse(_amount) ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('À ${widget.recipientWallet.code}'),
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Text(
              '${_amount.isEmpty ? '0' : _amount} XOF',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          _buildKeyRow(['1', '2', '3']),
          _buildKeyRow(['4', '5', '6']),
          _buildKeyRow(['7', '8', '9']),
          _buildKeyRow(['', '0', 'back']),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: amountValue > 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TransferConfirmationScreen(
                              recipientWallet: widget.recipientWallet,
                              amount: amountValue,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continuer',
                  style: TextStyle(fontSize: 16, color: AppColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
