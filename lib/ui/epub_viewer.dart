// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:epub_view/epub_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:openlib/services/database.dart';

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
  ConsumerState<ConsumerStatefulWidget> createState() => _EpubViewState();
}

class _EpubViewState extends ConsumerState<EpubViewerWidget> {
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
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    setState(() {
      _isLoading = true;
    });
    
    MyLibraryDb dataBase = MyLibraryDb.instance;
    String? epubConfig = await dataBase.getBookState(widget.fileName);
    
    _epubController = EpubController(
      document: EpubDocument.openFile(File(widget.filePath)),
      epubCfi: epubConfig?.startsWith('epubcfi') == true ? epubConfig : null,
    );
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _epubController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _epubController == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(AppLocalizations.of(context)!.loading),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: EpubViewActualChapter(
          controller: _epubController!,
          builder: (chapterValue) => Text(
            chapterValue?.chapter?.Title?.replaceAll('\n', '') ?? 'Loading...',
            textAlign: TextAlign.start,
          ),
        ),
      ),
      body: EpubView(
        controller: _epubController!,
        onChapterChanged: (chapter) async {
          final position = _epubController!.generateEpubCfi() ?? '';
          await saveEpubState(widget.fileName, position, ref);
        },
      ),
    );
  }
}
