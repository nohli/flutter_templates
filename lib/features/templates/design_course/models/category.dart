class Category {
  const Category({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.lessonCount,
    required this.money,
    required this.rating,
  });

  final String id;
  final String title;
  final String imagePath;
  final int lessonCount;
  final int money;
  final double rating;

  String get lessonLabel => '$lessonCount ${lessonCount == 1 ? 'lesson' : 'lessons'}';

  String get accessibilityLabel => 'Open $title sample course, $lessonLabel, rating $rating, price $money dollars';

  static const categoryList = <Category>[
    Category(
      id: 'user-interface-design',
      imagePath: 'assets/design_course/interFace1.png',
      title: 'User Interface Design',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Category(
      id: 'user-experience-research',
      imagePath: 'assets/design_course/interFace2.png',
      title: 'User Experience Research',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
    Category(
      id: 'design-systems',
      imagePath: 'assets/design_course/interFace2.png',
      title: 'Design Systems',
      lessonCount: 18,
      money: 22,
      rating: 4.7,
    ),
    Category(
      id: 'mobile-prototyping',
      imagePath: 'assets/design_course/interFace1.png',
      title: 'Mobile Prototyping',
      lessonCount: 20,
      money: 20,
      rating: 4.5,
    ),
  ];

  static const popularCourseList = <Category>[
    Category(
      id: 'app-design',
      imagePath: 'assets/design_course/interFace3.png',
      title: 'App Design Course',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      id: 'web-design',
      imagePath: 'assets/design_course/interFace4.png',
      title: 'Web Design Course',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category(
      id: 'responsive-layouts',
      imagePath: 'assets/design_course/interFace3.png',
      title: 'Responsive Layouts',
      lessonCount: 16,
      money: 28,
      rating: 4.7,
    ),
    Category(
      id: 'interaction-design',
      imagePath: 'assets/design_course/interFace4.png',
      title: 'Interaction Design',
      lessonCount: 21,
      money: 32,
      rating: 4.8,
    ),
  ];
}
