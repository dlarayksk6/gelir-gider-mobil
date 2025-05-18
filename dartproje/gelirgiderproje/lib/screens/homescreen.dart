import 'package:flutter/material.dart';
import 'package:gelirgiderproje/api_service.dart';
import 'package:gelirgiderproje/screens/edittransactionscreen.dart';
import 'package:gelirgiderproje/screens/profilscreen.dart';
import 'package:gelirgiderproje/screens/addtransactionscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Future<List<dynamic>?> _transactions;
  late TabController _tabController;
  final List<String> monthList = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  late String selectedMonth;
  late String selectedYear;

  @override
  void initState() {
    super.initState();
    selectedMonth = monthList[DateTime.now().month - 1];
    selectedYear = DateTime.now().year.toString();
    _tabController = TabController(length: 3, vsync: this);
    _transactions = ApiService().fetchData();
  }

  void _refreshData() {
    setState(() {
      _transactions = ApiService().fetchData();
    });
  }

  void _navigateToAddTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );
    if (result != null && result == true) {
      _refreshData();
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void _navigateToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Placeholder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            DropdownButton<String>(
              value: selectedMonth,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedMonth = newValue;
                    _refreshData();
                  });
                }
              },
              items:
                  monthList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedYear,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedYear = newValue;
                    _refreshData();
                  });
                }
              },
              items: List.generate(5, (index) {
                String year = (DateTime.now().year - index).toString();
                return DropdownMenuItem<String>(value: year, child: Text(year));
              }),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfile,
            tooltip: 'Profil',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tümü'),
            Tab(text: 'Gelir'),
            Tab(text: 'Gider'),
          ],
        ),
      ),
      body: _buildTransactionView(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.bar_chart),
              iconSize: 32,
              tooltip: 'İstatistikler',
              onPressed: _navigateToStatistics,
            ),
            FloatingActionButton(
              onPressed: _navigateToAddTransaction,
              child: const Icon(Icons.add),
              mini: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionView() {
    return FutureBuilder<List<dynamic>?>(
      future: _transactions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        }

        final allTransactions = snapshot.data ?? [];

        final filteredTransactions =
            allTransactions.where((tx) {
              try {
                final txDate = DateTime.parse(tx['tarih']);
                return txDate.month == (monthList.indexOf(selectedMonth) + 1) &&
                    txDate.year.toString() == selectedYear;
              } catch (_) {
                return false;
              }
            }).toList();

        return TabBarView(
          controller: _tabController,
          children: [
            _buildListView(filteredTransactions),
            _buildListView(
              filteredTransactions
                  .where((tx) => tx['islem'] == 'gelir')
                  .toList(),
            ),
            _buildListView(
              filteredTransactions
                  .where((tx) => tx['islem'] == 'gider')
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListView(List<dynamic> transactions) {
    if (transactions.isEmpty) {
      return const Center(child: Text('Kayıt bulunamadı.'));
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "${tx['islem'] == 'gelir' ? '+' : '-'} ${tx['miktar']}",
                      style: TextStyle(
                        color:
                            tx['islem'] == 'gelir' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx['kategori'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          tx['tarih'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'Düzenle') {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => EditTransactionScreen(
                                transaction: tx,
                                index: index,
                              ),
                        ),
                      );
                      if (result != null && result == true) {
                        _refreshData();
                      }
                    } else if (value == 'Sil') {
                      await ApiService().deleteTransaction(tx['_id']);
                      _refreshData();
                    }
                  },
                  itemBuilder:
                      (context) => const [
                        PopupMenuItem(value: 'Düzenle', child: Text('Düzenle')),
                        PopupMenuItem(value: 'Sil', child: Text('Sil')),
                      ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
