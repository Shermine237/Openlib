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

Future<void> launchEpubViewer(
    {required String fileName,
    required BuildContext context,
    required WidgetRef ref}) async {
  String path = await getFilePath(fileName);
  bool openWithExternalApp = ref.watch(openEpubWithExternalAppProvider);

  if (openWithExternalApp) {
    await OpenFile.open(path, linuxByProcess: true);
  } else {
    try {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return EpubViewerWidget(
          fileName: fileName,
        );
      }));
    } catch (e) {
      showSnackBar(context: context, message: 'Unable to open epub!');
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
      loading: () => Scaffold(
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
  late EpubController _epubController;
  
  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    MyLibraryDb dataBase = MyLibraryDb.instance;
    String? epubConfig = await dataBase.getBookState(widget.fileName);
    
    _epubController = EpubController(
      document: EpubDocument.openFile(File(widget.filePath)),
      epubCfi: epubConfig?.startsWith('epubcfi') == true ? epubConfig : null,
    );
  }

  @override
  void dispose() {
    _epubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: EpubViewActualChapter(
          controller: _epubController,
          builder: (chapterValue) => Text(
            chapterValue?.chapter?.Title?.replaceAll('\n', '') ?? 'Loading...',
            textAlign: TextAlign.start,
          ),
        ),
      ),
      body: EpubView(
        controller: _epubController,
        onChapterChanged: (chapter) {
          saveEpubState(widget.fileName, _epubController.generateEpubCfi(), ref);
        },
      ),
    );
  }
}
