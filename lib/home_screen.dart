import 'package:flutter/material.dart';

import 'app_identity.dart';
import 'app_theme.dart';
import 'model/homelist.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static const _layoutPreferenceKey = 'home-gallery-multiple-columns';

  final List<HomeList> _homeList = HomeList.homeList;
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
                  itemCount: _homeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval((1 / _homeList.length) * index, 1, curve: Curves.fastOutSlowIn),
                      ),
                    );
                    final HomeList item = _homeList[index];
                    return _HomeListCard(
                      animation: animation,
                      listData: item,
                      onTap: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => MediaQuery.withNoTextScaling(child: item.navigateScreen),
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
}

class _GalleryHeader extends StatelessWidget {
  const _GalleryHeader({required this.multiple, required this.onToggleLayout});

  static const _titleStyle = TextStyle(fontSize: 22, color: AppTheme.darkText, fontWeight: FontWeight.w700);

  final bool multiple;
  final VoidCallback onToggleLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final titlePainter = TextPainter(
          text: const TextSpan(text: AppIdentity.name, style: _titleStyle),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: 1,
        )..layout();
        final bool stackTitle = titlePainter.width > constraints.maxWidth - 112;
        final Widget toggle = Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox.square(
            dimension: 48,
            child: IconButton(
              tooltip: multiple ? 'Show one column' : 'Show multiple columns',
              onPressed: onToggleLayout,
              icon: Icon(multiple ? Icons.dashboard : Icons.view_agenda, color: AppTheme.darkGrey),
            ),
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
                  children: <Widget>[const SizedBox.square(dimension: 56), toggle],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: Text(AppIdentity.name, textAlign: TextAlign.center, style: _titleStyle),
              ),
            ],
          );
        }
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kToolbarHeight),
          child: Row(
            children: <Widget>[
              const SizedBox.square(dimension: 56),
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(AppIdentity.name, textAlign: TextAlign.center, style: _titleStyle),
                  ),
                ),
              ),
              toggle,
            ],
          ),
        );
      },
    );
  }
}

class _HomeListCard extends StatelessWidget {
  const _HomeListCard({required this.listData, required this.onTap, required this.animation});

  final HomeList listData;
  final VoidCallback onTap;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: listData.title,
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
                        Image.asset(listData.imagePath, fit: BoxFit.cover),
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
