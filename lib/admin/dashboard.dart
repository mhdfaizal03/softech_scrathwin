// admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:softech_scratch_n_win/models/services/firestore_services.dart';
import '../models/scratch_entry.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _service = FirestoreService();
  int? _selectedDiscount; // null => all

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scratch Results - Softroniics')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Text('Filter by discount: '),
                const SizedBox(width: 8),
                DropdownButton<int?>(
                  value: _selectedDiscount,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: 10, child: Text('10%')),
                    DropdownMenuItem(value: 15, child: Text('15%')),
                    DropdownMenuItem(value: 20, child: Text('20%')),
                    DropdownMenuItem(value: 25, child: Text('25%')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedDiscount = value);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ScratchEntry>>(
              stream: _service.listenEntries(discountFilter: _selectedDiscount),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final entries = snapshot.data ?? [];
                if (entries.isEmpty) {
                  return const Center(child: Text('No entries yet.'));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Age')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Discount')),
                      DataColumn(label: Text('Date')),
                    ],
                    rows: entries.map((e) {
                      return DataRow(
                        cells: [
                          DataCell(Text(e.name)),
                          DataCell(Text(e.age.toString())),
                          DataCell(Text(e.email)),
                          DataCell(Text(e.phone)),
                          DataCell(Text('${e.discount}%')),
                          DataCell(Text(e.createdAt.toString())),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
