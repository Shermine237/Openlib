// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Package imports:
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:openlib/l10n/app_localizations.dart';
import 'package:openlib/ui/home_page.dart';
import 'package:openlib/ui/mylibrary_page.dart';
import 'package:openlib/ui/search_page.dart';
import 'package:openlib/ui/settings_page.dart';
import 'package:openlib/ui/themes.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Project imports:
import 'package:openlib/services/database.dart' show MyLibraryDb;
import 'package:openlib/state/state.dart'
    show
        selectedIndexProvider,
        themeModeProvider,
        openPdfWithExternalAppProvider,
        openEpubWithExternalAppProvider,
        userAgentProvider,
        cookieProvider,
        localeProvider,
        databaseProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final database = MyLibraryDb.instance;
  await database.database;

  final darkModePref = await database.getPreference('darkMode');
  final pdfExternalPref = await database.getPreference('openPdfwithExternalApp');
  final epubExternalPref = await database.getPreference('openEpubwithExternalApp');

  bool isDarkMode = darkModePref == 1;
  bool openPdfwithExternalapp = pdfExternalPref == 1;
  bool openEpubwithExternalapp = epubExternalPref == 1;

  String browserUserAgent = await database.getBrowserOptions('userAgent');
  String browserCookie = await database.getBrowserOptions('cookie');

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            isDarkMode ? Colors.black : Colors.grey.shade200));
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(await database.database),
        themeModeProvider.overrideWith(
            (ref) => isDarkMode ? ThemeMode.dark : ThemeMode.light),
        openPdfWithExternalAppProvider
            .overrideWith((ref) => openPdfwithExternalapp),
        openEpubWithExternalAppProvider
            .overrideWith((ref) => openEpubwithExternalapp),
        userAgentProvider.overrideWith((ref) => browserUserAgent),
        cookieProvider.overrideWith((ref) => browserCookie),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Megalib',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale, // Utilise la langue système si null
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
      ],
      home: const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    MyLibraryPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Megalib"),
        titleTextStyle: Theme.of(context).textTheme.displayLarge,
      ),
      body: _widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: SafeArea(
        child: GNav(
          backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade200,
          haptic: true,
          tabBorderRadius: 50,
          tabActiveBorder: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          ),
          tabMargin: const EdgeInsets.fromLTRB(13, 6, 13, 2.5),
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 25),
          gap: 5,
          color: const Color.fromARGB(255, 255, 255, 255),
          activeColor: const Color.fromARGB(255, 255, 255, 255),
          iconSize: 19, // tab button icon size
          tabBackgroundColor: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6.5),
          tabs: [
            GButton(
              icon: Icons.trending_up,
              text: 'Home',
              iconColor: isDarkMode ? Colors.white : Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
              iconColor: isDarkMode ? Colors.white : Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            GButton(
              icon: Icons.collections_bookmark,
              text: 'My Library',
              iconColor: isDarkMode ? Colors.white : Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            GButton(
              icon: Icons.build,
              text: 'Settings',
              iconColor: isDarkMode ? Colors.white : Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: (index) async {
            ref.read(selectedIndexProvider.notifier).state = index;
          },
        ),
      ),
    );
  }
}
