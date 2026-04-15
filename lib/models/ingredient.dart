class Ingredient {
  final String id;
  final String name;
  final String category;
  final String emoji;

  const Ingredient({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
  });
}

// ── Sample data ────────────────────────────────────────────────────────────
const List<Ingredient> kIngredients = [
  // Dairy
  Ingredient(id: 'milk',        name: 'Milk',        category: 'Dairy',     emoji: '🥛'),
  Ingredient(id: 'butter',      name: 'Butter',      category: 'Dairy',     emoji: '🧈'),
  Ingredient(id: 'cheese',      name: 'Cheese',      category: 'Dairy',     emoji: '🧀'),
  Ingredient(id: 'eggs',        name: 'Eggs',        category: 'Dairy',     emoji: '🥚'),
  Ingredient(id: 'yogurt',      name: 'Yogurt',      category: 'Dairy',     emoji: '🫙'),
  Ingredient(id: 'cream',       name: 'Cream',       category: 'Dairy',     emoji: '🍶'),
  // Vegetables
  Ingredient(id: 'tomato',      name: 'Tomato',      category: 'Vegetable', emoji: '🍅'),
  Ingredient(id: 'onion',       name: 'Onion',       category: 'Vegetable', emoji: '🧅'),
  Ingredient(id: 'garlic',      name: 'Garlic',      category: 'Vegetable', emoji: '🧄'),
  Ingredient(id: 'potato',      name: 'Potato',      category: 'Vegetable', emoji: '🥔'),
  Ingredient(id: 'carrot',      name: 'Carrot',      category: 'Vegetable', emoji: '🥕'),
  Ingredient(id: 'spinach',     name: 'Spinach',     category: 'Vegetable', emoji: '🥬'),
  Ingredient(id: 'broccoli',    name: 'Broccoli',    category: 'Vegetable', emoji: '🥦'),
  Ingredient(id: 'capsicum',    name: 'Capsicum',    category: 'Vegetable', emoji: '🫑'),
  Ingredient(id: 'mushroom',    name: 'Mushroom',    category: 'Vegetable', emoji: '🍄'),
  Ingredient(id: 'corn',        name: 'Corn',        category: 'Vegetable', emoji: '🌽'),
  Ingredient(id: 'cucumber',    name: 'Cucumber',    category: 'Vegetable', emoji: '🥒'),
  Ingredient(id: 'lemon',       name: 'Lemon',       category: 'Vegetable', emoji: '🍋'),
  // Protein
  Ingredient(id: 'chicken',     name: 'Chicken',     category: 'Protein',   emoji: '🍗'),
  Ingredient(id: 'beef',        name: 'Beef',        category: 'Protein',   emoji: '🥩'),
  Ingredient(id: 'fish',        name: 'Fish',        category: 'Protein',   emoji: '🐟'),
  Ingredient(id: 'shrimp',      name: 'Shrimp',      category: 'Protein',   emoji: '🦐'),
  Ingredient(id: 'tofu',        name: 'Tofu',        category: 'Protein',   emoji: '🫘'),
  Ingredient(id: 'lentils',     name: 'Lentils',     category: 'Protein',   emoji: '🫘'),
  // Pantry
  Ingredient(id: 'pasta',       name: 'Pasta',       category: 'Pantry',    emoji: '🍝'),
  Ingredient(id: 'rice',        name: 'Rice',        category: 'Pantry',    emoji: '🍚'),
  Ingredient(id: 'bread',       name: 'Bread',       category: 'Pantry',    emoji: '🍞'),
  Ingredient(id: 'flour',       name: 'Flour',       category: 'Pantry',    emoji: '🌾'),
  Ingredient(id: 'olive_oil',   name: 'Olive Oil',   category: 'Pantry',    emoji: '🫒'),
  Ingredient(id: 'soy_sauce',   name: 'Soy Sauce',   category: 'Pantry',    emoji: '🍶'),
  Ingredient(id: 'canned_tomato', name: 'Canned Tomato', category: 'Pantry', emoji: '🥫'),
  Ingredient(id: 'coconut_milk', name: 'Coconut Milk', category: 'Pantry',  emoji: '🥥'),
  // Spices
  Ingredient(id: 'salt',        name: 'Salt',        category: 'Spice',     emoji: '🧂'),
  Ingredient(id: 'pepper',      name: 'Pepper',      category: 'Spice',     emoji: '🌶️'),
  Ingredient(id: 'cumin',       name: 'Cumin',       category: 'Spice',     emoji: '🌿'),
  Ingredient(id: 'turmeric',    name: 'Turmeric',    category: 'Spice',     emoji: '🟡'),
  Ingredient(id: 'paprika',     name: 'Paprika',     category: 'Spice',     emoji: '🌶️'),
  Ingredient(id: 'ginger',      name: 'Ginger',      category: 'Spice',     emoji: '🫚'),
  Ingredient(id: 'coriander',   name: 'Coriander',   category: 'Spice',     emoji: '🌿'),
  Ingredient(id: 'chili',       name: 'Chili',       category: 'Spice',     emoji: '🌶️'),
];
