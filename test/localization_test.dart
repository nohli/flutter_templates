import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/gallery/models/template_gallery_item.dart';
import 'package:templates/features/templates/channel_messenger/channel_messenger_home_screen.dart';
import 'package:templates/features/templates/dating_app/dating_inbox_screen.dart';
import 'package:templates/features/templates/dating_app/widgets/dating_profile_card.dart';
import 'package:templates/features/templates/design_course/home_design_course.dart';
import 'package:templates/features/templates/hotel_booking/calendar_popup_view.dart';
import 'package:templates/features/templates/hotel_booking/custom_calendar.dart';
import 'package:templates/features/templates/hotel_booking/smooth_star_rating.dart';
import 'package:templates/features/templates/private_messenger/private_messenger_home_screen.dart';
import 'package:templates/features/templates/social_feed/social_feed_home_screen.dart';
import 'package:templates/l10n/localizations.dart';
import 'package:templates/main.dart';

import 'generated/localization_messages.dart';
import 'localized_test_app.dart';

void main() {
  final source = _catalog('en');
  final keys = source.keys.where((key) => !key.startsWith('@')).toSet();

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('${locale.toLanguageTag()} resolves every message through the app delegates', (tester) async {
      expect(GlobalMaterialLocalizations.delegate.isSupported(locale), isTrue);
      expect(GlobalCupertinoLocalizations.delegate.isSupported(locale), isTrue);
      expect(GlobalWidgetsLocalizations.delegate.isSupported(locale), isTrue);
      late AppLocalizations l10n;
      await tester.pumpWidget(
        LocalizedTestApp(
          locale: locale,
          home: Builder(
            builder: (context) {
              l10n = context.l10n;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(l10n.localeName, locale.toString());
      for (final destination in TemplateGalleryDestination.values) {
        for (final isDark in [false, true]) {
          final asset = destination.galleryPreviewPath(l10n, dark: isDark);
          expect(asset, startsWith('assets/gallery/${locale.toString()}/'));
          final bytes = await rootBundle.load(asset);
          expect(bytes.getUint32(0), 0x89504E47, reason: asset);
          expect(bytes.getUint32(16), 402, reason: asset);
          expect(bytes.getUint32(20), 874, reason: asset);
        }
      }
      expect(l10n.number(1234.5), isNotEmpty);
      expect(l10n.money(1234.5, 'USD'), isNotEmpty);
      expect(l10n.percent(0.125, decimalDigits: 1), isNotEmpty);
      expect(l10n.clock(18, 42), isNotEmpty);
      final catalog = _catalog(l10n.localeName);
      expect(catalog.keys.where((key) => !key.startsWith('@')).toSet(), keys);
      final messages = readMessages(l10n);
      expect(messages.keys.toSet(), keys);
      for (final key in keys) {
        expect(messages[key], isNotEmpty, reason: key);
        if (!source.containsKey('@$key')) {
          expect(messages[key], catalog[key], reason: key);
        }
      }
      expect(l10n.lessonCount(1), isNot(l10n.lessonCount(2)));
      expect(l10n.profilePortrait('Ari', 'online'), isNot(l10n.profilePortrait('Ari', 'offline')));
      expect(l10n.chatMessageLabel('Ari', '18:42', '🍃'), contains('🍃'));
      for (final count in [0, 1, 2, 3, 5, 11, 21, 101]) {
        expect(l10n.lessonCount(count), isNotEmpty);
        expect(l10n.valueSampleHotels(count), isNotEmpty);
        expect(l10n.valueReviews(count), isNotEmpty);
        expect(l10n.valueConversationsNoPressurePickUpWhereverItFeelsNatural(count), isNotEmpty);
      }
      if (locale.languageCode == 'ar') {
        // The installed intl generic Arabic symbols use Latin digits
        expect(l10n.number(1234.5), '1,234.5');
        expect(l10n.number(2, decimalDigits: 1), '2.0');
        expect(l10n.number(4, minimumIntegerDigits: 2), '04');
        expect(l10n.lessonCount(0), 'لا دروس');
        expect(l10n.lessonCount(1), 'درس واحد');
        expect(l10n.lessonCount(2), 'درسان');
        expect(l10n.lessonCount(3), '3 دروس');
        expect(l10n.lessonCount(11), '11 درسًا');
        expect(l10n.lessonCount(101), '101 درس');
      }
      if (locale.languageCode == 'pl') {
        for (final (count, expected) in [
          (1, '1 lekcja'),
          (2, '2 lekcje'),
          (5, '5 lekcji'),
          (12, '12 lekcji'),
          (21, '21 lekcji'),
          (22, '22 lekcje'),
          (101, '101 lekcji'),
        ]) {
          expect(l10n.lessonCount(count), expected);
        }
        expect(l10n.valueSampleHotels(2), '2 przykładowe hotele');
        expect(l10n.valueSampleHotels(5), '5 przykładowych hoteli');
        expect(l10n.valueReviews(2), ' 2 opinie');
        expect(l10n.valueReviews(5), ' 5 opinii');
      }
      if (locale.languageCode == 'pt') {
        expect(l10n.lessonCount(0), '0 lições');
        expect(l10n.lessonCount(1), '1 lição');
        expect(l10n.lessonCount(2), '2 lições');
        expect(l10n.valueSampleHotels(0), '0 hotéis de exemplo');
        expect(l10n.valueReviews(0), ' 0 avaliações');
      }
      if (locale.languageCode == 'ro') {
        for (final (count, expected) in [
          (0, '0 lecții'),
          (1, '1 lecție'),
          (2, '2 lecții'),
          (20, '20 de lecții'),
          (21, '21 de lecții'),
          (101, '101 lecții'),
        ]) {
          expect(l10n.lessonCount(count), expected);
        }
        expect(l10n.valueSampleHotels(20), '20 de hoteluri de exemplu');
        expect(l10n.valueReviews(101), ' 101 recenzii');
      }
      if (locale.languageCode == 'cs') {
        for (final (count, expected) in [
          (1, '1 lekce'),
          (2, '2 lekce'),
          (4, '4 lekce'),
          (5, '5 lekcí'),
          (21, '21 lekcí'),
        ]) {
          expect(l10n.lessonCount(count), expected);
        }
        expect(l10n.valueSampleHotels(5), '5 ukázkových hotelů');
        expect(l10n.valueReviews(4), ' 4 recenze');
      }
      if (locale.languageCode == 'sk') {
        for (final (count, expected) in [
          (1, '1 lekcia'),
          (2, '2 lekcie'),
          (4, '4 lekcie'),
          (5, '5 lekcií'),
          (21, '21 lekcií'),
        ]) {
          expect(l10n.lessonCount(count), expected);
        }
        expect(l10n.valueSampleHotels(5), '5 ukážkových hotelov');
        expect(l10n.valueReviews(4), ' 4 recenzie');
      }
      if (locale.languageCode == 'hr') {
        for (final (count, expected) in [
          (1, '1 lekcija'),
          (2, '2 lekcije'),
          (5, '5 lekcija'),
          (11, '11 lekcija'),
          (21, '21 lekcija'),
          (22, '22 lekcije'),
        ]) {
          expect(l10n.lessonCount(count), expected);
        }
        expect(l10n.valueSampleHotels(12), '12 oglednih hotela');
        expect(l10n.valueSampleHotels(21), '21 ogledni hotel');
        expect(l10n.valueSampleHotels(22), '22 ogledna hotela');
        expect(l10n.valueReviews(4), ' 4 recenzije');
      }
      if (locale.languageCode == 'bg') {
        expect(l10n.lessonCount(1), '1 урок');
        expect(l10n.lessonCount(2), '2 урока');
        expect(l10n.lessonCount(21), '21 урока');
        expect(l10n.valueSampleHotels(1), '1 примерен хотел');
        expect(l10n.valueSampleHotels(2), '2 примерни хотела');
        expect(l10n.valueReviews(5), ' 5 отзива');
      }
      if (locale.languageCode == 'ru') {
        for (final (count, expected) in [
          (1, '1 урок'),
          (2, '2 урока'),
          (5, '5 уроков'),
          (11, '11 уроков'),
          (21, '21 урок'),
          (22, '22 урока'),
          (111, '111 уроков'),
        ]) {
          expect(l10n.lessonCount(count), expected);
        }
        expect(l10n.valueSampleHotels(21), '21 демонстрационный отель');
        expect(l10n.valueSampleHotels(22), '22 демонстрационных отеля');
        expect(l10n.valueSampleHotels(25), '25 демонстрационных отелей');
        expect(l10n.valueReviews(21), ' 21 отзыв');
        expect(l10n.valueReviews(22), ' 22 отзыва');
        expect(l10n.valueReviews(5), ' 5 отзывов');
      }
      if (locale.languageCode == 'uk') {
        for (final (count, expected) in [
          (1, '1 урок'),
          (2, '2 уроки'),
          (5, '5 уроків'),
          (11, '11 уроків'),
          (21, '21 урок'),
          (22, '22 уроки'),
          (111, '111 уроків'),
        ]) {
          expect(l10n.lessonCount(count), expected);
        }
        expect(l10n.valueSampleHotels(21), '21 демонстраційний готель');
        expect(l10n.valueSampleHotels(22), '22 демонстраційні готелі');
        expect(l10n.valueSampleHotels(25), '25 демонстраційних готелів');
        expect(l10n.valueReviews(21), ' 21 відгук');
        expect(l10n.valueReviews(22), ' 22 відгуки');
        expect(l10n.valueReviews(5), ' 5 відгуків');
      }
      if (locale.languageCode == 'zh' && locale.scriptCode == 'Hant') {
        expect(l10n.lessonCount(0), '0 堂課');
        expect(l10n.lessonCount(1), '1 堂課');
        expect(l10n.lessonCount(2), '2 堂課');
        expect(l10n.valueSampleHotels(3), locale.countryCode == 'HK' ? '3 間示例酒店' : '3 家範例飯店');
        expect(l10n.valueReviews(2), ' 2 則評論');
      }
      if (locale.languageCode == 'zh' && locale.scriptCode != 'Hant') {
        expect(l10n.lessonCount(0), '0 节课');
        expect(l10n.lessonCount(1), '1 节课');
        expect(l10n.lessonCount(2), '2 节课');
        expect(l10n.valueSampleHotels(3), '3 家示例酒店');
        expect(l10n.valueReviews(2), ' 2 条评价');
      }
      if (locale.languageCode == 'th') {
        expect(l10n.lessonCount(0), '0 บทเรียน');
        expect(l10n.lessonCount(1), '1 บทเรียน');
        expect(l10n.lessonCount(2), '2 บทเรียน');
        expect(l10n.valueSampleHotels(3), 'โรงแรมตัวอย่าง 3 แห่ง');
        expect(l10n.valueReviews(2), ' 2 รีวิว');
      }
      if (locale.languageCode == 'hi') {
        expect(l10n.lessonCount(0), '0 पाठ');
        expect(l10n.lessonCount(1), '1 पाठ');
        expect(l10n.lessonCount(2), '2 पाठ');
        expect(l10n.valueSampleHotels(3), '3 नमूना होटल');
        expect(l10n.valueReviews(0), ' 0 समीक्षाएँ');
        expect(l10n.valueReviews(1), ' 1 समीक्षा');
        expect(l10n.valueReviews(2), ' 2 समीक्षाएँ');
      }
      if (locale.languageCode == 'ko') {
        expect(l10n.lessonCount(0), '수업 0개');
        expect(l10n.lessonCount(1), '수업 1개');
        expect(l10n.lessonCount(2), '수업 2개');
        expect(l10n.valueSampleHotels(3), '예시 호텔 3개');
        expect(l10n.valueReviews(2), ' 후기 2개');
      }
      if (locale.languageCode == 'ja') {
        expect(l10n.lessonCount(0), '0 レッスン');
        expect(l10n.lessonCount(1), '1 レッスン');
        expect(l10n.lessonCount(2), '2 レッスン');
        expect(l10n.valueSampleHotels(3), 'サンプルホテル 3 件');
        expect(l10n.valueReviews(2), ' レビュー 2 件');
      }
      if (locale.languageCode == 'kk') {
        expect(l10n.lessonCount(0), '0 сабақ');
        expect(l10n.lessonCount(1), '1 сабақ');
        expect(l10n.lessonCount(2), '2 сабақ');
        expect(l10n.valueSampleHotels(3), '3 үлгі қонақүй');
        expect(l10n.valueReviews(2), ' 2 пікір');
      }
      if (locale.languageCode == 'vi') {
        expect(l10n.lessonCount(0), '0 bài học');
        expect(l10n.lessonCount(1), '1 bài học');
        expect(l10n.lessonCount(2), '2 bài học');
        expect(l10n.valueSampleHotels(3), '3 khách sạn minh họa');
        expect(l10n.valueReviews(2), ' 2 nhận xét');
      }
      if (locale.languageCode == 'tr') {
        expect(l10n.lessonCount(0), '0 ders');
        expect(l10n.lessonCount(1), '1 ders');
        expect(l10n.lessonCount(2), '2 ders');
        expect(l10n.valueSampleHotels(3), '3 örnek otel');
        expect(l10n.valueReviews(2), ' 2 yorum');
      }
      if (locale.languageCode == 'id' || locale.languageCode == 'ms') {
        expect(l10n.lessonCount(0), '0 pelajaran');
        expect(l10n.lessonCount(1), '1 pelajaran');
        expect(l10n.lessonCount(2), '2 pelajaran');
        expect(l10n.valueSampleHotels(3), '3 hotel contoh');
        expect(l10n.valueReviews(2), ' 2 ulasan');
      }
      if (locale.languageCode == 'he') {
        expect(l10n.lessonCount(0), '0 שיעורים');
        expect(l10n.lessonCount(1), 'שיעור אחד');
        expect(l10n.lessonCount(2), 'שני שיעורים');
        expect(l10n.lessonCount(10), '10 שיעורים');
        expect(l10n.valueSampleHotels(1), 'מלון אחד לדוגמה');
        expect(l10n.valueSampleHotels(2), '2 מלונות לדוגמה');
        expect(l10n.valueReviews(1), ' ביקורת אחת');
        expect(l10n.valueReviews(2), ' 2 ביקורות');
      }
      if (locale.languageCode == 'hu') {
        expect(l10n.lessonCount(0), '0 lecke');
        expect(l10n.lessonCount(1), '1 lecke');
        expect(l10n.lessonCount(2), '2 lecke');
        expect(l10n.valueSampleHotels(5), '5 mintaszállás');
        expect(l10n.valueReviews(2), ' 2 vélemény');
      }
      if (locale.languageCode == 'de') {
        expect(l10n.number(1234.5), '1.234,5');
        expect(l10n.number(2, decimalDigits: 1), '2,0');
      }
      expect(tester.takeException(), isNull);
    });
  }

  for (final language in ['en', 'ar']) {
    testWidgets('$language calendar range joins dates in reading order', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1;
        final start = DateTime(2030, 1, 2);
        final end = DateTime(2030, 1, 4);
        await tester.pumpWidget(
          LocalizedTestApp(
            locale: Locale(language),
            home: Scaffold(
              body: CalendarPopupView(
                initialStartDate: start,
                initialEndDate: end,
                minimumDate: DateTime(2030, 1, 1),
                onApplyClick: (_, _) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(CustomCalendarView));
        final direction = Directionality.of(context);
        for (final label in [context.l10n.previousMonth, context.l10n.nextMonth]) {
          final button = find.byTooltip(label);
          final icon = find.descendant(of: button, matching: find.byType(Icon));
          final glyph = tester.renderObject<RenderParagraph>(
            find.descendant(of: icon, matching: find.byType(RichText)),
          );
          final transform = glyph.getTransformTo(tester.renderObject(button));
          expect(transform.storage[0], direction == TextDirection.rtl ? -1 : 1, reason: label);
        }
        for (var weekday = 1; weekday <= 7; weekday++) {
          final date = DateTime(2030, 1, 7).add(Duration(days: weekday - 1));
          final fullName = DateFormat.EEEE(context.l10n.localeName).format(date);
          final shortName = MaterialLocalizations.of(context).narrowWeekdays[weekday % 7];
          final header = find.descendant(of: find.bySemanticsLabel(fullName), matching: find.text(shortName));
          expect(header, findsOneWidget, reason: fullName);
          final paragraph = tester.renderObject<RenderParagraph>(header);
          final runs = paragraph.getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: shortName.length));
          expect(runs.map((run) => run.top).toSet(), hasLength(1), reason: fullName);
        }
        BorderRadius rangeCap(DateTime date) {
          final label = DateFormat.yMMMMEEEEd(context.l10n.localeName).format(date);
          final cell = find.ancestor(of: find.bySemanticsLabel(label), matching: find.byType(Stack)).first;
          final box = tester.widget<DecoratedBox>(find.descendant(of: cell, matching: find.byType(DecoratedBox)).first);
          return (box.decoration as BoxDecoration).borderRadius!.resolve(direction);
        }

        final startCap = rangeCap(start);
        final endCap = rangeCap(end);
        if (direction == TextDirection.rtl) {
          expect(startCap.topRight.x, greaterThan(0));
          expect(startCap.topLeft, Radius.zero);
          expect(endCap.topLeft.x, greaterThan(0));
          expect(endCap.topRight, Radius.zero);
        } else {
          expect(startCap.topLeft.x, greaterThan(0));
          expect(startCap.topRight, Radius.zero);
          expect(endCap.topRight.x, greaterThan(0));
          expect(endCap.topLeft, Radius.zero);
        }
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      }
    });
  }

  for (final (preferred, expected) in [
    for (final locale in AppLocalizations.supportedLocales) (locale, locale.toString()),
    (const Locale('zh', 'CN'), 'zh_Hans_CN'),
    (const Locale('zh', 'TW'), 'zh_Hant_TW'),
    (const Locale('zh', 'HK'), 'zh_Hant_HK'),
  ]) {
    testWidgets('device language ${preferred.toLanguageTag()} selects $expected', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        tester.platformDispatcher.localesTestValue = [preferred, const Locale('en')];
        await tester.pumpWidget(const UiTemplatesApp());
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(Navigator).first);
        final l10n = context.l10n;
        expect(l10n.localeName, expected);
        final previews = tester
            .widgetList<Image>(find.byType(Image))
            .map((image) => image.image)
            .whereType<AssetImage>()
            .where((image) => image.assetName.startsWith('assets/gallery/'));
        expect(previews, isNotEmpty);
        expect(previews.map((image) => image.assetName), everyElement(startsWith('assets/gallery/$expected/')));
        expect(find.byTooltip(l10n.openNavigationMenu), findsOneWidget);
        expect(find.bySemanticsLabel(l10n.hotelBooking), findsOneWidget);
        expect(
          Directionality.of(context),
          ['ar', 'he'].contains(preferred.languageCode) ? TextDirection.rtl : TextDirection.ltr,
        );
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
        tester.platformDispatcher.clearLocalesTestValue();
      }
    });
  }

  testWidgets('Arabic banking keeps each exchange equation in reading order', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      tester.view.physicalSize = const Size(402, 874);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.localesTestValue = const [Locale('ar')];
      await tester.pumpWidget(const UiTemplatesApp());
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.bySemanticsLabel('تطبيق مصرفي شامل'));
      await tester.tap(find.bySemanticsLabel('تطبيق مصرفي شامل'));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(Navigator).first);
      final l10n = context.l10n;
      final equation = '${l10n.number(1)} EUR = ${l10n.number(1.17)} USD';
      final finder = find.text(equation);
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      final paragraph = tester.renderObject<RenderParagraph>(finder);
      final first = paragraph.getBoxesForSelection(const TextSelection(baseOffset: 0, extentOffset: 1)).single;
      final last = paragraph
          .getBoxesForSelection(TextSelection(baseOffset: equation.length - 1, extentOffset: equation.length))
          .single;
      expect(first.left, lessThan(last.left));
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
      tester.platformDispatcher.clearLocalesTestValue();
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    }
  });

  for (final (language, galleryLabel, query, title) in [
    ('tr', 'Tasarım kursu', 'KULLANICI', 'Kullanıcı arayüzü tasarımı'),
    ('tr', 'Tasarım kursu', 'SİSTEMLERİ', 'Tasarım sistemleri'),
    ('el', 'Μάθημα σχεδίασης', 'ΔΙΕΠΑΦΉΣ', 'Σχεδίαση διεπαφής χρήστη'),
    ('el', 'Μάθημα σχεδίασης', 'ΔΙΕΠΑΦΗΣ', 'Σχεδίαση διεπαφής χρήστη'),
    ('el', 'Μάθημα σχεδίασης', 'ΣΧΕΔΊΑΣΗΣ', 'Συστήματα σχεδίασης'),
    ('el', 'Μάθημα σχεδίασης', 'ΣΧΕΔΙΑΣΗΣ', 'Συστήματα σχεδίασης'),
    ('en', 'Design Course', 'USER INTERFACE', 'User Interface Design'),
  ]) {
    testWidgets('$language course search matches $query through the gallery', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        tester.platformDispatcher.localesTestValue = [Locale(language)];
        await tester.pumpWidget(const UiTemplatesApp());
        await tester.pumpAndSettle();
        await tester.tap(find.bySemanticsLabel(galleryLabel));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField), query);
        await tester.pumpAndSettle();

        expect(find.text(title), findsOneWidget);
        await tester.ensureVisible(find.text(title));
        expect(find.text(title).hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
        tester.platformDispatcher.clearLocalesTestValue();
      }
    });
  }

  for (final (language, introduction, course) in [
    ('bg', 'Избери своя', 'Курс по дизайн'),
    ('ca', 'Tria el teu', 'Curs de disseny'),
    ('de', 'Wähle deinen', 'Designkurs'),
    ('es', 'Elige tu', 'Curso de diseño'),
    ('hr', 'Odaberi svoj', 'Tečaj dizajna'),
    ('nb', 'Velg ditt', 'Designkurs'),
    ('no', 'Velg ditt', 'Designkurs'),
    ('pl', 'Wybierz swój', 'Kurs projektowania'),
    ('pt', 'Escolha seu', 'Curso de design'),
    ('ru', 'Выбери свой', 'Курс по дизайну'),
    ('uk', 'Вибери свій', 'Курс із дизайну'),
  ]) {
    testWidgets('$language course heading agrees with its course noun', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        tester.view.physicalSize = const Size(430, 932);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.localesTestValue = [Locale(language)];
        await tester.pumpWidget(const UiTemplatesApp());
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(Scaffold).first);
        final card = find.bySemanticsLabel(context.l10n.designCourse);
        await tester.ensureVisible(card);
        await tester.tap(card);
        await tester.pumpAndSettle();

        final heading = find.descendant(of: find.byType(DesignCourseHomeScreen), matching: find.text(introduction));
        expect(heading, findsOneWidget);
        expect(find.descendant(of: find.byType(DesignCourseHomeScreen), matching: find.text(course)), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
        tester.platformDispatcher.clearLocalesTestValue();
        tester.view.reset();
      }
    });
  }

  for (final (language, locale, title, captions) in <(String, String, String, List<String>)>[
    ('Greek', 'el', 'Προσωπικά οικονομικά', ['ΠΡΟΣΘΗΚΗ ΧΡΗΜΑΤΩΝ', 'ΑΙΤΗΜΑ', 'ΠΕΡΙΣΣΟΤΕΡΑ']),
    (
      'Greek',
      'el',
      'Γνωριμίες και επικοινωνία',
      ['ΠΟΡΤΡΕΤΟ 01 / 2 ΧΛΜ. ΜΑΚΡΙΑ', 'ΡΩΤΗΣΕ / Ο ΠΙΟ ΓΡΗΓΟΡΟΣ ΔΡΟΜΟΣ ΠΡΟΣ ΤΗΝ ΚΑΡΔΙΑ ΜΟΥ'],
    ),
    ('Greek', 'el', 'Δημόσια κοινωνική ροή', ['ΣΥΣΤΗΜΑΤΑ ΣΧΕΔΙΑΣΗΣ']),
    ('Turkish', 'tr', 'Kişisel finans', ['PARA EKLE', 'İSTE', 'DAHA FAZLA']),
    ('Turkish', 'tr', 'Flört ve sosyalleşme', ['PORTRE 01 / 2 KM UZAKTA', 'SORU / KALBİME GİDEN EN KISA YOL']),
    ('Turkish', 'tr', 'Herkese açık sosyal akış', ['TASARIM SİSTEMLERİ']),
  ]) {
    testWidgets('$language captions retain correct spelling in $title', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        tester.view.physicalSize = const Size(430, 932);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.localesTestValue = [Locale(locale), const Locale('en')];
        await tester.pumpWidget(const UiTemplatesApp());
        await tester.pumpAndSettle();
        final card = find.bySemanticsLabel(title);
        expect(tester.element(card).l10n.localeName, locale);
        await tester.ensureVisible(card);
        await tester.tap(card);
        await tester.pumpAndSettle();

        for (final caption in captions) {
          expect(find.text(caption), findsOneWidget);
        }
        final profiles = find.byType(DatingProfileCard);
        if (profiles.evaluate().isNotEmpty) {
          expect(profiles, findsNWidgets(2));
          expect(tester.getSize(profiles.first), tester.getSize(profiles.last));
        }
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
        tester.platformDispatcher.clearLocalesTestValue();
        tester.view.reset();
      }
    });
  }

  testWidgets('Arabic rating taps and accessibility values follow the displayed stars', (tester) async {
    double? selected;
    await tester.pumpWidget(
      LocalizedTestApp(
        locale: const Locale('ar'),
        home: Scaffold(
          body: Center(
            child: SmoothStarRating(size: 32, allowHalfRating: false, onRatingChanged: (value) => selected = value),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final stars = tester.getRect(find.byType(SmoothStarRating));
    await tester.tapAt(Offset(stars.right - 1, stars.center.dy));
    expect(selected, 1);
    await tester.tapAt(Offset(stars.left + 1, stars.center.dy));
    expect(selected, 5);
    final semantics = tester.widget<Semantics>(
      find.descendant(of: find.byType(SmoothStarRating), matching: find.byType(Semantics)).first,
    );
    expect(semantics.properties.value, '0 من 5');
    expect(semantics.properties.increasedValue, '1');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic navigation opens from the leading edge and supports directional dragging', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.localesTestValue = const [Locale('ar'), Locale('en')];
      await tester.pumpWidget(const UiTemplatesApp());
      await tester.pumpAndSettle();

      final open = find.byTooltip('فتح قائمة التنقل');
      expect(Directionality.of(tester.element(open)), TextDirection.rtl);
      expect(tester.getCenter(open).dx, greaterThan(200));
      await tester.tap(open);
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('المساعدة'));
      await tester.pumpAndSettle();
      expect(find.text('كيف يمكننا مساعدتك؟'), findsOneWidget);

      await tester.dragFrom(const Offset(390, 400), const Offset(-260, 0));
      await tester.pumpAndSettle();
      expect(find.byTooltip('إغلاق قائمة التنقل'), findsOneWidget);
      await tester.dragFrom(const Offset(170, 400), const Offset(220, 0));
      await tester.pumpAndSettle();
      expect(find.byTooltip('فتح قائمة التنقل'), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
      tester.platformDispatcher.clearLocalesTestValue();
      tester.view.reset();
    }
  });

  for (final language in ['nb', 'no']) {
    testWidgets('the real app selects Norwegian for $language-NO', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        tester.platformDispatcher.localesTestValue = [Locale(language, 'NO'), const Locale('en')];
        await tester.pumpWidget(const UiTemplatesApp());
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(Scaffold).first);
        expect(context.l10n.localeName, language);
        expect(find.byTooltip('Åpne navigasjonsmenyen'), findsOneWidget);
        expect(find.bySemanticsLabel('Hotellbestilling'), findsOneWidget);
        expect(find.bySemanticsLabel('Hotel Booking'), findsNothing);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
        tester.platformDispatcher.clearLocalesTestValue();
      }
    });
  }

  for (final language in ['he', 'iw']) {
    testWidgets('the real app selects Hebrew and RTL navigation for $language-IL', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        tester.view.physicalSize = const Size(400, 900);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.localesTestValue = [Locale(language, 'IL'), const Locale('en')];
        await tester.pumpWidget(const UiTemplatesApp());
        await tester.pumpAndSettle();

        final open = find.byTooltip('פתיחת תפריט הניווט');
        final context = tester.element(open);
        expect(context.l10n.localeName, 'he');
        expect(Directionality.of(context), TextDirection.rtl);
        expect(tester.getCenter(open).dx, greaterThan(200));
        expect(find.bySemanticsLabel('הזמנת מלונות'), findsOneWidget);
        expect(find.bySemanticsLabel('Hotel Booking'), findsNothing);
        await tester.tap(open);
        await tester.pumpAndSettle();
        await tester.tap(find.bySemanticsLabel('עזרה'));
        await tester.pumpAndSettle();
        expect(find.text('איך נוכל לעזור לך?'), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
        tester.platformDispatcher.clearLocalesTestValue();
        tester.view.reset();
      }
    });
  }

  testWidgets('the real app selects French from the device language list', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      tester.platformDispatcher.localesTestValue = const [Locale('fr', 'FR'), Locale('en')];
      await tester.pumpWidget(const UiTemplatesApp());
      await tester.pumpAndSettle();

      final context = tester.element(find.byTooltip('Ouvrir le menu de navigation'));
      expect(context.l10n.localeName, 'fr_FR');
      expect(find.bySemanticsLabel('Réservation d’hôtel'), findsOneWidget);
      expect(find.bySemanticsLabel('Hotel Booking'), findsNothing);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
      tester.platformDispatcher.clearLocalesTestValue();
    }
  });

  testWidgets('dating translates an open conversation while preserving sent text and a draft', (tester) async {
    await _changeLanguage(tester, const DatingInboxScreen(appearance: AppAppearance.light), (locale) async {
      await tester.tap(find.bySemanticsLabel('Open conversation with Ari'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'My own message 🍃');
      await tester.pump();
      final sendButton = find.ancestor(of: find.byTooltip('Send message'), matching: find.byType(IconButton));
      expect(tester.widget<IconButton>(sendButton).onPressed, isNotNull);
      await tester.tap(find.byTooltip('Send message'));
      await tester.pumpAndSettle();
      expect(find.text('My own message 🍃'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Unfinished draft');

      locale.value = const Locale('fr');
      await tester.pumpAndSettle();

      expect(find.text('Marché conclu. Je connais l’endroit idéal.'), findsOneWidget);
      expect(find.text('Deal. I know exactly the place.'), findsNothing);
      expect(find.text('My own message 🍃'), findsOneWidget);
      expect(find.text('Unfinished draft'), findsOneWidget);
      expect(find.text('TOI / MAINTENANT'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('a private chat translates its contact and keeps user messages and a draft', (tester) async {
    await _changeLanguage(tester, const PrivateMessengerHomeScreen(), (locale) async {
      await tester.tap(find.bySemanticsLabel(RegExp('^Open private chat with Dad')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'See you soon 🍃');
      await tester.tap(find.byTooltip('Send message'));
      await tester.pumpAndSettle();
      expect(find.text('See you soon 🍃'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Keep this draft');

      locale.value = const Locale('fr');
      await tester.pumpAndSettle();

      expect(find.text('Papa'), findsOneWidget);
      expect(find.text('Dad'), findsNothing);
      expect(find.text('See you soon 🍃'), findsOneWidget);
      expect(find.text('Keep this draft'), findsOneWidget);
      expect(find.text('La table du jardin est réservée 🌿'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('an open social thread translates the sample post and preserves a reply draft', (tester) async {
    await _changeLanguage(tester, const SocialFeedHomeScreen(), (locale) async {
      final post = english.smallInterfacesBecomeMemorableWhenEveryMotionExplainsWhereThe;
      await tester.tap(find.text(post));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'My reply 🍃');

      locale.value = const Locale('fr');
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Les petites interfaces deviennent mémorables quand chaque mouvement explique d’où vient le contenu.',
        ),
        findsOneWidget,
      );
      expect(find.text(post), findsNothing);
      expect(find.text('My reply 🍃'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('an open channel translates its identity while retaining subscription changes', (tester) async {
    await _changeLanguage(tester, const ChannelMessengerHomeScreen(), (locale) async {
      await tester.tap(find.text('Design Dispatch'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Subscribed'));
      await tester.pumpAndSettle();

      locale.value = const Locale('fr');
      await tester.pumpAndSettle();

      expect(find.text('Le courrier du design'), findsOneWidget);
      expect(find.text('Design Dispatch'), findsNothing);
      expect(find.widgetWithText(FilledButton, 'S’abonner'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('an open course translates its title while retaining its saved state', (tester) async {
    await _changeLanguage(tester, const DesignCourseHomeScreen(), (locale) async {
      await tester.tap(find.text('User Interface Design'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Save sample course'));
      await tester.pumpAndSettle();

      locale.value = const Locale('fr');
      await tester.pumpAndSettle();

      expect(find.text('Conception d’interfaces'), findsOneWidget);
      expect(find.text('User Interface Design'), findsNothing);
      expect(find.byTooltip('Retirer le cours fictif enregistré'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

Future<void> _changeLanguage(
  WidgetTester tester,
  Widget home,
  Future<void> Function(ValueNotifier<Locale>) exercise,
) async {
  final locale = ValueNotifier(const Locale('en'));
  final semantics = tester.ensureSemantics();
  try {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      ValueListenableBuilder(
        valueListenable: locale,
        builder: (context, value, child) => LocalizedTestApp(locale: value, home: home),
      ),
    );
    await tester.pumpAndSettle();
    await exercise(locale);
  } finally {
    semantics.dispose();
    locale.dispose();
    tester.view.reset();
  }
}

Map<String, dynamic> _catalog(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync()) as Map<String, dynamic>;
