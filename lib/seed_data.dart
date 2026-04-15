import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedData() async {
  final firestore = FirebaseFirestore.instance;

  final ingredientsString =
      await rootBundle.loadString('assets/ingredients.json');
  final ingredients = jsonDecode(ingredientsString);

  for (var item in ingredients) {
    await firestore.collection('ingredients').doc(item['id']).set(item);
  }

  final recipesString =
      await rootBundle.loadString('assets/recipes.json');
  final recipes = jsonDecode(recipesString);

  for (var item in recipes) {
    await firestore.collection('recipes').doc(item['id']).set(item);
  }

  print("✅ Data seeded successfully!");
}