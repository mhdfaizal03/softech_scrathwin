// scratch_entry.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ScratchEntry {
  final String id;
  final String name;
  final int age;
  final String email;
  final String phone;
  final int discount;
  final String code; // 👈 NEW
  final DateTime createdAt;

  ScratchEntry({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.phone,
    required this.discount,
    required this.code, // 👈 NEW
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'email': email,
      'phone': phone,
      'discount': discount,
      'code': code, // 👈 NEW
      'createdAt': createdAt,
    };
  }

  factory ScratchEntry.fromMap(String id, Map<String, dynamic> map) {
    return ScratchEntry(
      id: id,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      discount: map['discount'] ?? 0,
      code: map['code'] ?? '', // 👈 NEW
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
