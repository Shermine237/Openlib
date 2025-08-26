// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:epub_view/epub_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:openlib/services/stats_service.dart';
import 'package:openlib/services/api_service.dart';
import 'package:openlib/services/local_storage_service.dart';

// Project imports:
import 'package:openlib/services/files.dart' show getFilePath;
import 'package:openlib/ui/components/snack_bar_widget.dart';
import 'package:openlib/state/state.dart'
    show
        filePathProvider,
        saveEpubState,
        openEpubWithExternalAppProvider;
import 'package:openlib/l10n/app_localizations.dart';

Future<void> launchEpubViewer({
  required String fileName,
  required BuildContext context,
  required WidgetRef ref,
}) async {
  // Capture the context before async operation
  final currentContext = context;
  
  final path = await getFilePath(fileName);
  
  if (ref.read(openEpubWithExternalAppProvider)) {
    await OpenFile.open(path, linuxByProcess: true);
  } else {
    try {
      // Check if the widget is still mounted before using context
      if (currentContext.mounted) {
        Navigator.push(
          currentContext,
          MaterialPageRoute(builder: (BuildContext context) {
            return EpubViewerWidget(
              fileName: fileName,
            );
          }),
        );
      }
    } catch (e) {
      // Check if the widget is still mounted before showing snackbar
      if (currentContext.mounted) {
        showSnackBar(
          context: currentContext,
          message: AppLocalizations.of(currentContext)!.couldNotOpenPdf,
        );
      }
    }
  }
}

class EpubViewerWidget extends ConsumerStatefulWidget {
  const EpubViewerWidget({super.key, required this.fileName});

  final String fileName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EpubViewerState();
}

class _EpubViewerState extends ConsumerState<EpubViewerWidget> {
  late final StatsService _statsService;
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final storage = await LocalStorageService.getInstance();
    _statsService = StatsService(ApiService(), storage);
    _statsService.startReading(widget.fileName);
  }

  @override
  void dispose() {
    // Terminer et envoyer les statistiques
    _statsService.endReading();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filePath = ref.watch(filePathProvider(widget.fileName));
    return filePath.when(
      data: (data) {
        return EpubReader(filePath: data, fileName: widget.fileName);
      },
      error: (error, stack) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(AppLocalizations.of(context)!.error),
          ),
          body: Center(
            child: Text(AppLocalizations.of(context)!.errorLoadingEpub),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class EpubReader extends ConsumerStatefulWidget {
  const EpubReader({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  final String filePath;
  final String fileName;

  @override
  ConsumerState<EpubReader> createState() => _EpubReaderState();
}

class _EpubReaderState extends ConsumerState<EpubReader> {
  EpubController? _epubController;
  late final StatsService _statsService;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadBook();
  }

  Future<void> _initializeServices() async {
    final storage = await LocalStorageService.getInstance();
    _statsService = StatsService(ApiService(), storage);
  }

  Future<void> _loadBook() async {
    try {
      final filePath = await getFilePath(widget.fileName);
      final document = EpubDocument.openFile(File(filePath));
      _epubController = EpubController(document: document);

      // Attendre que le document soit chargé pour obtenir les informations
      final loadedDocument = await document;
      
      // Dans epub_view 3.2.0, utiliser une approche simple et robuste
      // Commencer avec une valeur par défaut et l'ajuster si possible
      int totalPages = 1; // Valeur par défaut sécurisée
      
      try {
        // Essayer d'obtenir le nombre d'éléments dans le spine
        final spineItems = loadedDocument.Schema?.Package?.Spine?.Items;
        if (spineItems != null && spineItems.isNotEmpty) {
          totalPages = spineItems.length;
        }
      } catch (e) {
        // En cas d'erreur, garder la valeur par défaut
        totalPages = 1;
      }
      
      _statsService.startReading(
        widget.fileName,
        totalPages: totalPages,
      );
      setState(() {});
    } catch (e) {
      // En cas d'erreur, initialiser avec des valeurs par défaut
      _statsService.startReading(
        widget.fileName,
        totalPages: 0,
      );
      setState(() {});
    }
  }

  void _onPageChanged() {
    _currentPage++;
    _statsService.logPageRead(_currentPage);
  }

  @override
  void dispose() {
    _epubController?.dispose();
    _statsService.endReading();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: _epubController == null
          ? const Center(child: CircularProgressIndicator())
          : EpubView(
              controller: _epubController!,
              onChapterChanged: (chapter) async {
                final position = _epubController!.generateEpubCfi() ?? '';
                await saveEpubState(widget.fileName, position, ref);
                _onPageChanged();
              },
            ),
    );
  }
}
