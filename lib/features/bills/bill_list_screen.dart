import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/api_service.dart';
import '../../core/app_colors.dart';
import '../../core/wallet_provider.dart';
import '../../models/facture.dart';
import 'bill_payment_confirmation_screen.dart';

class BillListScreen extends StatefulWidget {
  final String serviceName;

  const BillListScreen({super.key, required this.serviceName});

  @override
  State<BillListScreen> createState() => _BillListScreenState();
}

class _BillListScreenState extends State<BillListScreen> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Facture> _factures = [];
  final Set<String> _selectedReferences = {};

  @override
  void initState() {
    super.initState();
    _loadFactures();
  }

  String _formatXof(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'XOF',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Future<void> _loadFactures() async {
    final walletCode = context.read<WalletProvider>().wallet?.code;
    if (walletCode == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final factures = await _apiService.getCurrentFactures(
        walletCode,
        unite: widget.serviceName,
      );
      setState(() {
        _factures = factures.where((f) => !f.payee).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des factures';
        _isLoading = false;
      });
    }
  }

  void _toggleSelection(String reference) {
    setState(() {
      if (_selectedReferences.contains(reference)) {
        _selectedReferences.remove(reference);
      } else {
        _selectedReferences.add(reference);
      }
    });
  }

  double get _selectedTotal {
    return _factures
        .where((f) => _selectedReferences.contains(f.reference))
        .fold(0, (sum, f) => sum + f.montant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textSecondary,
        elevation: 0,
        title: Text('Factures ${widget.serviceName}'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            )
          : _factures.isEmpty
          ? const Center(
              child: Text(
                'Aucune facture impayée',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _factures.length,
              itemBuilder: (context, index) {
                final facture = _factures[index];
                final isSelected = _selectedReferences.contains(
                  facture.reference,
                );
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    onChanged: (_) => _toggleSelection(facture.reference),
                    activeColor: AppColors.primary,
                    checkColor: Colors.white,
                    title: Text(
                      facture.reference,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: facture.dateFacture != null
                        ? Text(
                            facture.dateFacture!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          )
                        : null,
                    secondary: Text(
                      _formatXof(facture.montant),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: _selectedReferences.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final selectedFactures = _factures
                        .where((f) => _selectedReferences.contains(f.reference))
                        .toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BillPaymentConfirmationScreen(
                          serviceName: widget.serviceName,
                          selectedFactures: selectedFactures,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Payer ${_selectedReferences.length} facture(s) — ${_formatXof(_selectedTotal)}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
    );
  }
}
