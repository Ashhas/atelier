import 'package:flutter/material.dart';

class DetailContainer extends StatelessWidget {
  const DetailContainer({super.key, required this.goalCategoryId});

  final String goalCategoryId;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Detail: $goalCategoryId')));
}
