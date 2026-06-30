import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'bill_list_screen.dart';

class BillProviderScreen extends StatefulWidget {
  const BillProviderScreen({super.key});

  @override
  State<BillProviderScreen> createState() => _BillProviderScreenState();
}

class _BillProviderScreenState extends State<BillProviderScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<Map<String, dynamic>> _providers = [
    {
      'name': 'ISM',
      'image': 'assets/images/ism.png',
      'color': Color(0xFF8B5E34),
    },
    {
      'name': 'WOYAFAL',
      'image': 'assets/images/woyofal.png',
      'color': Color(0xFFE94B4B),
    },
    {
      'name': 'RAPIDO',
      'image': 'assets/images/rapido.png',
      'color': Color(0xFFE08A3C),
    },
    {
      'name': 'SENELEC',
      'image': 'assets/images/senelec.jpeg',
      'color': Color(0xFF3B7DD8),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProviders {
    if (_query.isEmpty) return _providers;
    return _providers
        .where(
          (p) => (p['name'] as String).toLowerCase().contains(
            _query.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textSecondary,
        elevation: 0,
        title: const Text('Paiements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Chercher par nom',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Factures',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _filteredProviders.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun fournisseur trouvé',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: _filteredProviders.length,
                      itemBuilder: (context, index) {
                        final provider = _filteredProviders[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BillListScreen(
                                  serviceName: provider['name'] as String,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: provider['color'] as Color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: provider['image'] != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Image.asset(
                                          provider['image'] as String,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : Icon(
                                        provider['icon'] as IconData,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                provider['name'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
