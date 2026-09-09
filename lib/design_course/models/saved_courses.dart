import 'category.dart';

class SavedCourses {
  SavedCourses();

  final _courseIds = <String>{};

  bool contains(Category course) => _courseIds.contains(course.id);

  bool toggle(Category course) {
    if (!_courseIds.add(course.id)) {
      _courseIds.remove(course.id);
    }
    return contains(course);
  }
}
