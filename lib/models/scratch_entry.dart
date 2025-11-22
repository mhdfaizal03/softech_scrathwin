import 'package:cloud_firestore/cloud_firestore.dart';

class ScratchEntry {
  final String id;
  final String name;
  final String qualification; // ✅ instead of age
  final String email;
  final String phone;
  final int discount;
  final String code;
  final DateTime createdAt;

  ScratchEntry({
    required this.id,
    required this.name,
    required this.qualification,
    required this.email,
    required this.phone,
    required this.discount,
    required this.code,
    required this.createdAt,
  });

  factory ScratchEntry.fromMap(String id, Map<String, dynamic> map) {
    return ScratchEntry(
      id: id,
      name: map['name'] as String? ?? '',
      qualification: map['qualification'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      discount: (map['discount'] as num?)?.toInt() ?? 0,
      code: map['code'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qualification': qualification,
      'email': email,
      'phone': phone,
      'discount': discount,
      'code': code,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
