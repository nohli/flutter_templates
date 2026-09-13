import 'package:flutter/material.dart';

import '../../app/app_appearance.dart';
import '../../app/app_identity.dart';
import '../templates/dating_app/dating_home_screen.dart';
import '../templates/banking_super_app/banking_home_screen.dart';
import '../templates/channel_messenger/channel_messenger_home_screen.dart';
import '../templates/design_course/home_design_course.dart';
import '../templates/design_course/models/saved_courses.dart';
import '../templates/finance_app/finance_home_screen.dart';
import '../templates/fitness_app/fitness_app_home_screen.dart';
import '../templates/hotel_booking/hotel_home_screen.dart';
import '../templates/language_learning/language_learning_home_screen.dart';
import '../templates/private_messenger/private_messenger_home_screen.dart';
import '../templates/social_feed/social_feed_home_screen.dart';
import 'models/template_gallery_item.dart';
import 'template_gallery_artwork.dart';

class TemplateGalleryScreen extends StatefulWidget {
  const TemplateGalleryScreen({required this.appearance, required this.onAppearanceChanged, super.key});

  final AppAppearance appearance;
  final ValueChanged<AppAppearance> onAppearanceChanged;

  @override
  State<TemplateGalleryScreen> createState() => _TemplateGalleryScreenState();
}

class _TemplateGalleryScreenState extends State<TemplateGalleryScreen> with SingleTickerProviderStateMixin {
  static const _layoutPreferenceKey = 'home-gallery-multiple-columns';

  final _items = TemplateGalleryItem.items;
  final _savedCourses = SavedCourses();
  var _multiple = true;
  var _restoredLayoutPreference = false;

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_restoredLayoutPreference) {
      _multiple =
          PageStorage.maybeOf(context)?.readState(context, identifier: _layoutPreferenceKey) as bool? ?? _multiple;
      _restoredLayoutPreference = true;
    }
    if (MediaQuery.disableAnimationsOf(context)) {
      _animationController.value = 1;
    } else if (_animationController.value == 0 && !_animationController.isAnimating) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          _GalleryHeader(
            appearance: widget.appearance,
            onAppearanceChanged: widget.onAppearanceChanged,
            multiple: _multiple,
            onToggleLayout: () {
              setState(() {
                _multiple = !_multiple;
              });
              PageStorage.maybeOf(context)?.writeState(context, _multiple, identifier: _layoutPreferenceKey);
            },
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final columnCount = _multiple && constraints.maxWidth >= 720 ? 3 : (_multiple ? 2 : 1);
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final animation = Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval((1 / _items.length) * index, 1, curve: Curves.fastOutSlowIn),
                      ),
                    );
                    final item = _items[index];
                    return _TemplateGalleryCard(
                      animation: animation,
                      item: item,
                      onTap: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                MediaQuery.withNoTextScaling(child: _screenFor(item.destination)),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _screenFor(TemplateGalleryDestination destination) => switch (destination) {
    TemplateGalleryDestination.hotelBooking => HotelHomeScreen(appearance: widget.appearance),
    TemplateGalleryDestination.fitness => FitnessAppHomeScreen(appearance: widget.appearance),
    TemplateGalleryDestination.designCourse => DesignCourseHomeScreen(
      appearance: widget.appearance,
      savedCourses: _savedCourses,
    ),
    TemplateGalleryDestination.personalFinance => FinanceHomeScreen(appearance: widget.appearance),
    TemplateGalleryDestination.dating => DatingHomeScreen(appearance: widget.appearance),
    TemplateGalleryDestination.languageLearning => LanguageLearningHomeScreen(appearance: widget.appearance),
    TemplateGalleryDestination.socialFeed => SocialFeedHomeScreen(appearance: widget.appearance),
    TemplateGalleryDestination.bankingSuperApp => BankingHomeScreen(appearance: widget.appearance),
    TemplateGalleryDestination.channelMessenger => ChannelMessengerHomeScreen(appearance: widget.appearance),
    TemplateGalleryDestination.privateMessenger => PrivateMessengerHomeScreen(appearance: widget.appearance),
  };
}

class _GalleryHeader extends StatelessWidget {
  const _GalleryHeader({
    required this.appearance,
    required this.onAppearanceChanged,
    required this.multiple,
    required this.onToggleLayout,
  });

  final AppAppearance appearance;
  final ValueChanged<AppAppearance> onAppearanceChanged;
  final bool multiple;
  final VoidCallback onToggleLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final titleStyle = TextStyle(
          fontSize: 22,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        );
        final titlePainter = TextPainter(
          text: TextSpan(text: AppIdentity.name, style: titleStyle),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: 1,
        )..layout();
        final stackTitle = titlePainter.width > constraints.maxWidth - 208;
        final actions = Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox.square(
                dimension: 48,
                child: AppAppearanceButton(appearance: appearance, onChanged: onAppearanceChanged),
              ),
              SizedBox.square(
                dimension: 48,
                child: IconButton(
                  tooltip: multiple ? 'Show one column' : 'Show multiple columns',
                  onPressed: onToggleLayout,
                  icon: Icon(multiple ? Icons.dashboard : Icons.view_agenda),
                ),
              ),
            ],
          ),
        );
        if (stackTitle) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: kToolbarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[const SizedBox.square(dimension: 56), actions],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: Text(AppIdentity.name, textAlign: TextAlign.center, style: titleStyle),
              ),
            ],
          );
        }
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kToolbarHeight),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 104),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(AppIdentity.name, textAlign: TextAlign.center, style: titleStyle),
                  ),
                ),
              ),
              actions,
            ],
          ),
        );
      },
    );
  }
}

class _TemplateGalleryCard extends StatelessWidget {
  const _TemplateGalleryCard({required this.item, required this.onTap, required this.animation});

  final TemplateGalleryItem item;
  final VoidCallback onTap;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: item.title,
      button: true,
      onTap: onTap,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, _) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(0.0, 50 * (1.0 - animation.value), 0.0),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        MediaQuery.withNoTextScaling(child: TemplateGalleryArtwork(item: item)),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                            onTap: onTap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
