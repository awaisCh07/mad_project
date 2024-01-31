import 'package:flutter/material.dart';

class Employee {
  String id;
  String name;
  String email;
  String imageUrl;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl = '',
  });
}
