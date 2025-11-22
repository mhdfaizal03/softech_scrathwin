import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softech_scratch_n_win/models/scratch_entry.dart';

class FirestoreService {
  FirestoreService()
    : _collection = FirebaseFirestore.instance.collection('scratch_entries');

  final CollectionReference<Map<String, dynamic>> _collection;

  /// Normalize phone number (keep only digits)
  String _normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'\D'), '');
  }

  Future<ScratchEntry?> getEntryByEmailOrPhone(
    String email,
    String phone,
  ) async {
    final normalizedEmail = email.trim();
    final normalizedPhone = _normalizePhone(phone);

    // 🔹 First try email
    final query = await _collection
        .where('email', isEqualTo: normalizedEmail)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return ScratchEntry.fromMap(doc.id, doc.data());
    }

    // 🔹 Then try phone
    final phoneQuery = await _collection
        .where('phone', isEqualTo: normalizedPhone)
        .limit(1)
        .get();

    if (phoneQuery.docs.isNotEmpty) {
      final doc = phoneQuery.docs.first;
      return ScratchEntry.fromMap(doc.id, doc.data());
    }

    return null;
  }

  /// Check if we can still give [discount] today, limited to [maxPerDay]
  Future<bool> canGiveDiscountToday(int discount, int maxPerDay) async {
    final now = DateTime.now();

    final query = await _collection
        .where('discount', isEqualTo: discount)
        .get();

    return query.docs.length < maxPerDay;
  }

  Future<ScratchEntry> createEntry({
    required String name,
    required String qualification, // ✅ replaced age
    required String email,
    required String phone,
    required int discount,
    required String code,
  }) async {
    final now = DateTime.now();
    final normalizedPhone = _normalizePhone(phone);

    final docRef = await _collection.add({
      'name': name.trim(),
      'qualification': qualification.trim(), // ✅ new field
      'email': email.trim(),
      'phone': normalizedPhone,
      'discount': discount,
      'code': code.trim(),
      'createdAt': Timestamp.fromDate(now),
    });

    final snapshot = await docRef.get();
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Scratch entry document has no data (id: ${docRef.id})');
    }

    return ScratchEntry.fromMap(docRef.id, data);
  }

  Stream<List<ScratchEntry>> listenEntries({int? discountFilter}) {
    Query<Map<String, dynamic>> query = _collection;

    if (discountFilter != null) {
      query = query.where('discount', isEqualTo: discountFilter);
    }

    // Always order by createdAt (latest first)
    query = query.orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ScratchEntry.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}
