class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> steps;
  final int cookTime;
  final int servings;
  final String cuisine;
  final String difficulty;
  final bool isVeg;

  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.cookTime,
    required this.servings,
    required this.cuisine,
    required this.difficulty,
    required this.isVeg,
  });
}

// ── Sample data ────────────────────────────────────────────────────────────
const List<Recipe> kRecipes = [
  Recipe(
    id: 'pasta_aglio',
    name: 'Pasta Aglio e Olio',
    ingredients: ['pasta', 'garlic', 'olive_oil', 'chili', 'salt', 'pepper'],
    steps: [
      'Boil pasta in salted water until al dente.',
      'Slice garlic thinly and sauté in olive oil with chili flakes.',
      'Drain pasta, reserving ½ cup pasta water.',
      'Toss pasta in the garlic oil, adding pasta water to emulsify.',
      'Season with salt and pepper. Serve immediately.',
    ],
    cookTime: 20, servings: 2, cuisine: 'Italian', difficulty: 'Easy', isVeg: true,
  ),
  Recipe(
    id: 'tomato_omelette',
    name: 'Tomato Omelette',
    ingredients: ['eggs', 'tomato', 'onion', 'salt', 'pepper', 'butter'],
    steps: [
      'Dice tomato and onion finely.',
      'Beat eggs with salt and pepper.',
      'Melt butter in a pan over medium heat.',
      'Pour in eggs, add tomato and onion.',
      'Fold and serve hot.',
    ],
    cookTime: 10, servings: 1, cuisine: 'Continental', difficulty: 'Easy', isVeg: true,
  ),
  Recipe(
    id: 'chicken_stir_fry',
    name: 'Chicken Stir Fry',
    ingredients: ['chicken', 'capsicum', 'onion', 'garlic', 'soy_sauce', 'ginger', 'olive_oil'],
    steps: [
      'Slice chicken into thin strips.',
      'Heat oil in a wok over high heat.',
      'Stir fry garlic and ginger for 30 seconds.',
      'Add chicken and cook until golden.',
      'Add vegetables and soy sauce, toss for 3 minutes.',
      'Serve over rice.',
    ],
    cookTime: 25, servings: 2, cuisine: 'Asian', difficulty: 'Medium', isVeg: false,
  ),
  Recipe(
    id: 'dal_tadka',
    name: 'Dal Tadka',
    ingredients: ['lentils', 'tomato', 'onion', 'garlic', 'cumin', 'turmeric', 'chili', 'butter', 'salt'],
    steps: [
      'Pressure cook lentils with turmeric and salt.',
      'Heat butter, add cumin seeds until they splutter.',
      'Add onion, garlic, and cook until golden.',
      'Add tomatoes and cook until soft.',
      'Pour tadka over cooked dal and simmer 5 minutes.',
    ],
    cookTime: 35, servings: 4, cuisine: 'Indian', difficulty: 'Easy', isVeg: true,
  ),
  Recipe(
    id: 'fried_rice',
    name: 'Egg Fried Rice',
    ingredients: ['rice', 'eggs', 'onion', 'garlic', 'soy_sauce', 'olive_oil', 'salt', 'pepper'],
    steps: [
      'Cook rice and let it cool completely.',
      'Heat oil in a wok, scramble eggs and set aside.',
      'Sauté garlic and onion until fragrant.',
      'Add cold rice and stir fry on high heat.',
      'Add soy sauce and eggs, toss well.',
    ],
    cookTime: 20, servings: 2, cuisine: 'Asian', difficulty: 'Easy', isVeg: true,
  ),
  Recipe(
    id: 'butter_chicken',
    name: 'Butter Chicken',
    ingredients: ['chicken', 'tomato', 'onion', 'garlic', 'ginger', 'cream', 'butter', 'cumin', 'paprika', 'salt'],
    steps: [
      'Marinate chicken in yogurt and spices for 30 min.',
      'Grill or pan-fry chicken until charred.',
      'Blend tomatoes, onion, garlic, ginger into a sauce.',
      'Cook sauce in butter, add spices.',
      'Add chicken and cream, simmer 15 minutes.',
    ],
    cookTime: 50, servings: 4, cuisine: 'Indian', difficulty: 'Medium', isVeg: false,
  ),
  Recipe(
    id: 'mushroom_soup',
    name: 'Cream of Mushroom Soup',
    ingredients: ['mushroom', 'onion', 'garlic', 'butter', 'cream', 'flour', 'salt', 'pepper'],
    steps: [
      'Sauté onion and garlic in butter until soft.',
      'Add mushrooms and cook until golden.',
      'Stir in flour and cook 1 minute.',
      'Add stock gradually, stirring constantly.',
      'Blend until smooth, stir in cream.',
      'Season and serve with crusty bread.',
    ],
    cookTime: 30, servings: 3, cuisine: 'Continental', difficulty: 'Easy', isVeg: true,
  ),
  Recipe(
    id: 'fish_curry',
    name: 'Coconut Fish Curry',
    ingredients: ['fish', 'coconut_milk', 'tomato', 'onion', 'garlic', 'ginger', 'turmeric', 'chili', 'salt'],
    steps: [
      'Marinate fish with turmeric and salt.',
      'Sauté onion, garlic, ginger until golden.',
      'Add tomatoes and spices, cook 5 minutes.',
      'Pour in coconut milk and bring to simmer.',
      'Add fish and cook gently for 10 minutes.',
    ],
    cookTime: 30, servings: 3, cuisine: 'Asian', difficulty: 'Medium', isVeg: false,
  ),
  Recipe(
    id: 'caprese_salad',
    name: 'Caprese Salad',
    ingredients: ['tomato', 'cheese', 'olive_oil', 'salt', 'pepper'],
    steps: [
      'Slice tomatoes and mozzarella evenly.',
      'Arrange alternating slices on a plate.',
      'Drizzle with olive oil.',
      'Season with salt and pepper.',
      'Garnish with fresh basil if available.',
    ],
    cookTime: 5, servings: 2, cuisine: 'Italian', difficulty: 'Easy', isVeg: true,
  ),
  Recipe(
    id: 'potato_soup',
    name: 'Creamy Potato Soup',
    ingredients: ['potato', 'onion', 'garlic', 'butter', 'cream', 'salt', 'pepper'],
    steps: [
      'Dice potatoes and onion.',
      'Sauté onion and garlic in butter.',
      'Add potatoes and cover with water or stock.',
      'Simmer until potatoes are tender.',
      'Blend half the soup, stir in cream.',
    ],
    cookTime: 35, servings: 4, cuisine: 'Continental', difficulty: 'Easy', isVeg: true,
  ),
];
