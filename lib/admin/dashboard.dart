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
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 700 && size.width < 1100;
    final bool isDesktop = size.width >= 1100;
    final bool isWide = isTablet || isDesktop;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('SoftTac Mania – Admin'),
        centerTitle: !isWide,
      ),
      body: Column(
        children: [
          _buildFilters(context, isWide),
          // 🔹 Only ONE Expanded in body: it wraps the StreamBuilder
          Expanded(
            child: StreamBuilder<List<ScratchEntry>>(
              stream: _service.listenEntries(discountFilter: _selectedDiscount),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: SelectableText(
                      'Error loading entries.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final entries = snapshot.data ?? [];
                if (entries.isEmpty) {
                  return const Center(child: Text('No entries yet.'));
                }

                // 🔍 client-side search filter
                final filteredEntries = entries.where((e) {
                  if (_searchQuery.isEmpty) return true;
                  final q = _searchQuery.toLowerCase();
                  return e.name.toLowerCase().contains(q) ||
                      e.email.toLowerCase().contains(q) ||
                      e.phone.toLowerCase().contains(q);
                }).toList();

                if (filteredEntries.isEmpty) {
                  return const Center(
                    child: Text('No entries match your filter/search.'),
                  );
                }

                final double horizontalPadding = isDesktop ? 32 : 12;

                // 🔹 IMPORTANT: we no longer put a Column-with-Expanded
                // inside another Column. We clearly split summary row and body.
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(filteredEntries, isWide),
                      const SizedBox(height: 12),
                      // Single Expanded here inside this Column
                      Expanded(
                        child: isWide
                            ? _buildTableView(filteredEntries)
                            : _buildMobileListView(filteredEntries),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Top filter + search bar
  Widget _buildFilters(BuildContext context, bool isWide) {
    final double padding = isWide ? 16 : 12;

    final dropdown = DropdownButton<int?>(
      value: _selectedDiscount,
      hint: const Text('All'),
      items: const [
        DropdownMenuItem<int?>(value: null, child: Text('All')),
        DropdownMenuItem<int?>(value: 10, child: Text('10%')),
        DropdownMenuItem<int?>(value: 15, child: Text('15%')),
        DropdownMenuItem<int?>(value: 20, child: Text('20%')),
        DropdownMenuItem<int?>(value: 25, child: Text('25%')),
      ],
      onChanged: (value) {
        setState(() => _selectedDiscount = value);
      },
    );

    final searchField = Expanded(
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search by name, email or phone',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
      ),
    );

    return Padding(
      padding: EdgeInsets.all(padding),
      child: isWide
          ? Row(
              children: [
                const Text(
                  'Filter by discount:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                dropdown,
                const SizedBox(width: 24),
                searchField,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Filter by discount:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    dropdown,
                  ],
                ),
                const SizedBox(height: 12),
                searchField,
              ],
            ),
    );
  }

  // 🔹 Summary chips: total users + per discount
  Widget _buildSummaryRow(List<ScratchEntry> entries, bool isWide) {
    final total = entries.length;

    final counts = <int, int>{};
    for (final e in entries) {
      counts[e.discount] = (counts[e.discount] ?? 0) + 1;
    }

    final chips = <Widget>[
      Chip(
        label: Text(
          'Total: $total',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      ...counts.entries.map((e) => Chip(label: Text('${e.key}% : ${e.value}'))),
    ];

    return Align(
      alignment: isWide ? Alignment.centerLeft : Alignment.center,
      child: Wrap(spacing: 8, runSpacing: 4, children: chips),
    );
  }

  // 🔹 Desktop / tablet: DataTable view
  Widget _buildTableView(List<ScratchEntry> entries) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 700),
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith<Color?>(
            (states) => Colors.grey[200],
          ),
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Qualification')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Discount')),
            DataColumn(label: Text('Date')),
          ],
          rows: entries.map((e) {
            return DataRow(
              cells: [
                DataCell(Text(e.name)),
                DataCell(Text(e.qualification)),
                DataCell(Text(e.email)),
                DataCell(Text(e.phone)),
                DataCell(Text('${e.discount}%')),
                DataCell(Text(_formatDate(e.createdAt))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // 🔹 Mobile: Card list view
  Widget _buildMobileListView(List<ScratchEntry> entries) {
    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final e = entries[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + discount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        e.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${e.discount}% OFF',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                if (e.qualification.isNotEmpty) ...[
                  Expanded(
                    child: Text(
                      e.qualification,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],

                Expanded(
                  child: Text(
                    e.email,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: Text(
                    e.phone,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(e.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Code: ${e.code}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 Simple date formatter (no intl dependency)
  String _formatDate(DateTime date) {
    final d = date.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy $hh:$min';
  }
}
