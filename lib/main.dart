// Dart imports:
import 'dart:io';
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Package imports:
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:openlib/l10n/app_localizations.dart';
import 'package:openlib/routes/routes.dart';
import 'package:openlib/services/api_service.dart';
import 'package:openlib/services/error_reporting_service.dart';
import 'package:openlib/services/local_storage_service.dart';
import 'package:openlib/screens/auth/login_screen.dart';
import 'package:openlib/screens/auth/register_screen.dart';
import 'package:openlib/ui/home_page.dart';
import 'package:openlib/ui/mylibrary_page.dart';
import 'package:openlib/ui/search_page.dart';
import 'package:openlib/ui/settings_page.dart';
import 'package:openlib/ui/splash_screen.dart';
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
        localeNotifierProvider,
        databaseProvider,
        authStateProvider;

Future<void> _initializeApp() async {
  // S'assurer que les liaisons Flutter sont initialisées avant tout
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le service de rapport d'erreur dès le début
  final storage = await LocalStorageService.getInstance();
  final api = ApiService();
  final errorReporter = ErrorReportingService(api, storage);

  // Configuration du gestionnaire d'erreurs global de Flutter
  FlutterError.onError = (details) {
    errorReporter.setCurrentAction('Erreur Flutter non gérée');
    errorReporter.reportError(
      details.exception,
      details.stack ?? StackTrace.current,
    );
  };

  // Initialiser sqflite pour desktop
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
  }

  // Initialiser la base de données
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

  // Configurer le style de la barre système
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Vérifier si l'utilisateur est connecté
  final token = await ApiService().getToken();
  final initialRoute = token != null ? Routes.home : Routes.login;

  // Lancer l'application
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(await database.database),
        themeModeProvider.overrideWith((ref) => isDarkMode ? ThemeMode.dark : ThemeMode.light),
        openPdfWithExternalAppProvider.overrideWith((ref) => openPdfwithExternalapp),
        openEpubWithExternalAppProvider.overrideWith((ref) => openEpubwithExternalapp),
        userAgentProvider.overrideWith((ref) => browserUserAgent),
        cookieProvider.overrideWith((ref) => browserCookie),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

void main() {
  // Activer le mode fatal pour les erreurs de zone en debug
  if (kDebugMode) {
    BindingBase.debugZoneErrorsAreFatal = true;
  }

  runZonedGuarded(
    () async {
      await _initializeApp();
    },
    (error, stack) {
      // Utiliser le service de rapport d'erreur pour les erreurs de zone
      final storage = LocalStorageService.getInstance();
      storage.then((s) {
        final errorService = ErrorReportingService(ApiService(), s);
        errorService.setCurrentAction('Erreur de zone non gérée');
        errorService.reportError(error, stack);
      });
    },
  );
}

class MyApp extends ConsumerWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupérer les préférences de l'utilisateur
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeNotifierProvider);
    final isAuthenticated = ref.watch(authStateProvider);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: isAuthenticated ? const MainScreen() : const LoginScreen(),
      routes: {
        Routes.login: (context) => const LoginScreen(),
        Routes.register: (context) => const RegisterScreen(),
        Routes.home: (context) => const MainScreen(),
      },
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ApiService().removeToken();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, Routes.login);
              }
            },
          ),
        ],
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
          iconSize: 19,
          tabBackgroundColor: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6.5),
          tabs: [
            GButton(
              icon: Icons.trending_up,
              text: AppLocalizations.of(context)!.home,
              iconColor: isDarkMode ? Colors.white : Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            GButton(
              icon: Icons.search,
              text: AppLocalizations.of(context)!.search,
              iconColor: isDarkMode ? Colors.white : Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            GButton(
              icon: Icons.collections_bookmark,
              text: AppLocalizations.of(context)!.myLibrary,
              iconColor: isDarkMode ? Colors.white : Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            GButton(
              icon: Icons.build,
              text: AppLocalizations.of(context)!.settings,
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
