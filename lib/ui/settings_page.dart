// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openlib/l10n/app_localizations.dart';
import 'package:openlib/services/files.dart';
import 'package:openlib/services/api_service.dart';
import 'package:openlib/state/state.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:openlib/services/database.dart';
import 'package:openlib/ui/about_page.dart';
import 'package:openlib/ui/components/page_title_widget.dart';

import 'package:openlib/state/state.dart'
    show
        themeModeProvider,
        openPdfWithExternalAppProvider,
        openEpubWithExternalAppProvider,
        localeNotifierProvider;

Future<void> requestStoragePermission() async {
  bool permissionGranted = false;
  // Check whether the device is running Android 11 or higher
  DeviceInfoPlugin plugin = DeviceInfoPlugin();
  AndroidDeviceInfo android = await plugin.androidInfo;
  // Android < 11
  if (android.version.sdkInt < 33) {
    if (await Permission.storage.request().isGranted) {
      permissionGranted = true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    }
  }
  // Android > 11
  else {
    if (await Permission.manageExternalStorage.request().isGranted) {
      permissionGranted = true;
    } else if (await Permission.manageExternalStorage
        .request()
        .isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.manageExternalStorage.request().isDenied) {
      permissionGranted = false;
    }
  }
  debugPrint("Storage permission status: $permissionGranted"); // Replaced print with debugPrint
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _syncPreferences(BuildContext context, WidgetRef ref) async {
    final apiService = ApiService();
    final themeMode = ref.read(themeModeProvider);
    final openPdfWithExternalApp = ref.read(openPdfWithExternalAppProvider);
    final openEpubWithExternalApp = ref.read(openEpubWithExternalAppProvider);
    final locale = ref.read(localeNotifierProvider);

    final preferences = {
      'themeMode': themeMode.toString(),
      'openPdfWithExternalApp': openPdfWithExternalApp,
      'openEpubWithExternalApp': openEpubWithExternalApp,
      'locale': locale?.toString(),
    };

    try {
      await apiService.syncUserPreferences(preferences);
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation des préférences: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!; // Non-null assertion car on sait que c'est toujours disponible
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);
    MyLibraryDb dataBase = MyLibraryDb.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(AppLocalizations.of(context)!.settings),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                subtitle: Text(
                  locale == null
                      ? l10n.systemDefault
                      : locale.languageCode == 'fr'
                          ? l10n.french
                          : l10n.english,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(l10n.selectLanguage),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Option langue système
                            ListTile(
                              title: Text(l10n.systemDefault),
                              onTap: () async {
                                ref.read(localeNotifierProvider.notifier).setLocale(null);
                                Navigator.pop(context);
                                if (!context.mounted) return;
                                await _syncPreferences(context, ref);
                              },
                            ),
                            // Option anglais
                            ListTile(
                              title: Text(l10n.english),
                              onTap: () async {
                                ref.read(localeNotifierProvider.notifier).setLocale(const Locale('en'));
                                Navigator.pop(context);
                                if (!context.mounted) return;
                                await _syncPreferences(context, ref);
                              },
                            ),
                            // Option français
                            ListTile(
                              title: Text(l10n.french),
                              onTap: () async {
                                ref.read(localeNotifierProvider.notifier).setLocale(const Locale('fr'));
                                Navigator.pop(context);
                                if (!context.mounted) return;
                                await _syncPreferences(context, ref);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: Text(l10n.darkMode),
                value: themeMode == ThemeMode.dark,
                onChanged: (bool value) async {
                  final newThemeMode = value ? ThemeMode.dark : ThemeMode.light;
                  ref.read(themeModeProvider.notifier).state = newThemeMode;
                  await dataBase.savePreference('darkMode', value);
                  if (Platform.isAndroid) {
                    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                        systemNavigationBarColor:
                            value ? Colors.black : Colors.grey.shade200));
                  }
                  // Éviter d'utiliser le context après un await
                  if (!context.mounted) return;
                  await _syncPreferences(context, ref);
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.picture_as_pdf),
                title: Text(l10n.openPdfWithExternalApp),
                value: ref.watch(openPdfWithExternalAppProvider),
                onChanged: (bool value) async {
                  debugPrint('Opening PDFs with external app: $value'); // Replaced print with debugPrint
                  ref.read(openPdfWithExternalAppProvider.notifier).state = value;
                  await dataBase.savePreference('openPdfwithExternalApp', value);
                  // Éviter d'utiliser le context après un await
                  if (!context.mounted) return;
                  await _syncPreferences(context, ref);
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.book),
                title: Text(l10n.openEpubWithExternalApp),
                value: ref.watch(openEpubWithExternalAppProvider),
                onChanged: (bool value) async {
                  ref.read(openEpubWithExternalAppProvider.notifier).state = value;
                  await dataBase.savePreference('openEpubwithExternalApp', value);
                  // Éviter d'utiliser le context après un await
                  if (!context.mounted) return;
                  await _syncPreferences(context, ref);
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: Text(l10n.changeStoragePath),
                onTap: () async {
                  final currentDirectory =
                      await dataBase.getPreference('bookStorageDirectory');
                  String? pickedDirectory =
                      await FilePicker.platform.getDirectoryPath();
                  if (pickedDirectory == null) {
                    return;
                  }
                  await requestStoragePermission();
                  // Attempt moving existing books to the new directory
                  moveFolderContents(currentDirectory, pickedDirectory);
                  dataBase.savePreference(
                      'bookStorageDirectory', pickedDirectory);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(l10n.about),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const AboutPage();
                  }));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
