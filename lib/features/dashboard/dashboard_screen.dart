import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:badwallet_mobile/core/wallet_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _balanceVisible = true;

  String _formatXof(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'XOF',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.loadWallet(),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.phoneNumber ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Icon(
                    Icons.account_circle,
                    size: 32,
                    color: Color(0xFF1E293B),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Carte solde
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Solde disponible',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(
                            () => _balanceVisible = !_balanceVisible,
                          ),
                          child: Icon(
                            _balanceVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _balanceVisible
                          ? _formatXof(provider.balance)
                          : '•••••••',
                      style: const TextStyle(
                        color: Color(0xFFF59E0B),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Actions rapides
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickAction(
                    icon: Icons.send,
                    label: 'Transférer',
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.receipt_long,
                    label: 'Payer',
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.history,
                    label: 'Historique',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Dernières transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (provider.status == WalletStatus.loading)
                const Center(child: CircularProgressIndicator())
              else if (provider.transactions.isEmpty)
                const Text(
                  'Aucune transaction récente',
                  style: TextStyle(color: Colors.grey),
                )
              else
                ...provider.transactions.take(5).map((t) {
                  final isNegative =
                      t.type == 'RETRAIT' ||
                      t.type == 'TRANSFERT' ||
                      t.type == 'PAIEMENT';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isNegative
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          child: Icon(
                            isNegative
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: isNegative ? Colors.red : Colors.green,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.type,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                t.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${isNegative ? '-' : '+'}${_formatXof(t.montant)}',
                          style: TextStyle(
                            color: isNegative ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFFF59E0B)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
