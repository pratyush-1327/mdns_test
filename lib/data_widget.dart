import 'package:flutter/material.dart';

class DataWidget extends StatelessWidget {
  final dynamic data;

  const DataWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        'Data: $data',
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }
}
