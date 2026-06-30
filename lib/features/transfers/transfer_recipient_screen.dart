import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/app_colors.dart';
import '../../models/wallet.dart';
import 'transfer_amount_screen.dart';

class TransferRecipientScreen extends StatefulWidget {
  const TransferRecipientScreen({super.key});

  @override
  State<TransferRecipientScreen> createState() =>
      _TransferRecipientScreenState();
}

class _TransferRecipientScreenState extends State<TransferRecipientScreen> {
  final ApiService _apiService = ApiService();
  final _phoneController = TextEditingController(text: '+221');
  final _phoneRegex = RegExp(r'^\+221\d{9}$');

  bool _isLoading = false;
  String? _errorMessage;
  Wallet? _recipientWallet;

  Future<void> _verifyRecipient() async {
    final phone = _phoneController.text.trim();

    if (!_phoneRegex.hasMatch(phone)) {
      setState(() {
        _errorMessage = 'Numéro invalide. Format attendu : +221XXXXXXXXX';
        _recipientWallet = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _recipientWallet = null;
    });

    try {
      final wallet = await _apiService.getWalletByPhone(phone);
      setState(() {
        _recipientWallet = wallet;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Destinataire introuvable';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Transférer à'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Numéro du destinataire',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) {
                if (_recipientWallet != null || _errorMessage != null) {
                  setState(() {
                    _recipientWallet = null;
                    _errorMessage = null;
                  });
                }
              },
              onSubmitted: (_) => _verifyRecipient(),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.errorAccent),
              ),
            if (_recipientWallet != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _recipientWallet!.code,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _recipientWallet!.email,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (_recipientWallet != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TransferAmountScreen(
                                    recipientWallet: _recipientWallet!,
                                  ),
                                ),
                              );
                            }
                          : _verifyRecipient),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _recipientWallet != null ? 'Continuer' : 'Vérifier',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
