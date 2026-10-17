import '../../../../l10n/localizations.dart';

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

  String lessonLabel(AppLocalizations l10n) => l10n.lessonCount(lessonCount);

  String accessibilityLabel(AppLocalizations l10n) => l10n.courseAccessibility(title, lessonLabel(l10n), rating, money);

  static List<Category> categoryList(AppLocalizations l10n) => <Category>[
    Category(
      id: 'user-interface-design',
      imagePath: 'assets/design_course/interFace1.png',
      title: l10n.userInterfaceDesign,
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Category(
      id: 'user-experience-research',
      imagePath: 'assets/design_course/interFace2.png',
      title: l10n.userExperienceResearch,
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
    Category(
      id: 'design-systems',
      imagePath: 'assets/design_course/interFace2.png',
      title: l10n.designSystemsLabel,
      lessonCount: 18,
      money: 22,
      rating: 4.7,
    ),
    Category(
      id: 'mobile-prototyping',
      imagePath: 'assets/design_course/interFace1.png',
      title: l10n.mobilePrototyping,
      lessonCount: 20,
      money: 20,
      rating: 4.5,
    ),
  ];

  static List<Category> popularCourseList(AppLocalizations l10n) => <Category>[
    Category(
      id: 'app-design',
      imagePath: 'assets/design_course/interFace3.png',
      title: l10n.appDesignCourse,
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      id: 'web-design',
      imagePath: 'assets/design_course/interFace4.png',
      title: l10n.webDesignCourse,
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category(
      id: 'responsive-layouts',
      imagePath: 'assets/design_course/interFace3.png',
      title: l10n.responsiveLayouts,
      lessonCount: 16,
      money: 28,
      rating: 4.7,
    ),
    Category(
      id: 'interaction-design',
      imagePath: 'assets/design_course/interFace4.png',
      title: l10n.interactionDesign,
      lessonCount: 21,
      money: 32,
      rating: 4.8,
    ),
  ];
}
