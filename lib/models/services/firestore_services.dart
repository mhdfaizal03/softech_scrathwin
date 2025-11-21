import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softech_scratch_n_win/models/scratch_entry.dart';

class FirestoreService {
  final _collection = FirebaseFirestore.instance.collection('scratch_entries');

  Future<ScratchEntry?> getEntryByEmailOrPhone(
    String email,
    String phone,
  ) async {
    final query = await _collection.where('email', isEqualTo: email).get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return ScratchEntry.fromMap(doc.id, doc.data());
    }

    final phoneQuery = await _collection.where('phone', isEqualTo: phone).get();

    if (phoneQuery.docs.isNotEmpty) {
      final doc = phoneQuery.docs.first;
      return ScratchEntry.fromMap(doc.id, doc.data());
    }

    return null;
  }

  Future<bool> canGiveDiscountToday(int discount, int maxPerDay) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final query = await _collection
        .where('discount', isEqualTo: discount)
        .where(
          'createdAt',
          //  isGreaterThanOrEqualTo: startOfDay
        )
        .get();

    return query.docs.length < maxPerDay;
  }

  Future<ScratchEntry> createEntry({
    required String name,
    required int age,
    required String email,
    required String phone,
    required int discount,
    required String code, // 👈 NEW
  }) async {
    final docRef = await _collection.add({
      'name': name,
      'age': age,
      'email': email,
      'phone': phone,
      'discount': discount,
      'code': code, // 👈 NEW
      'createdAt': DateTime.now(),
    });

    final snapshot = await docRef.get();
    return ScratchEntry.fromMap(snapshot.id, snapshot.data()!);
  }

  Stream<List<ScratchEntry>> listenEntries({int? discountFilter}) {
    Query<Map<String, dynamic>> query = _collection.orderBy(
      'createdAt',
      descending: true,
    );

    if (discountFilter != null) {
      query = query.where('discount', isEqualTo: discountFilter);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ScratchEntry.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}
