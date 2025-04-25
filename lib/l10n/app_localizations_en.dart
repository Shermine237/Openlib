// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Openlib';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get myLibrary => 'My Library';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get about => 'About';

  @override
  String get trending => 'Trending';

  @override
  String get errorLoading => 'Error loading content';

  @override
  String get noBooks => 'No books found';

  @override
  String get downloadComplete => 'Download complete';

  @override
  String get downloadError => 'Download error';

  @override
  String get openWith => 'Open with';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get changeStoragePath => 'Change storage path';

  @override
  String get errorLoadingEpub => 'Error loading epub file';

  @override
  String get error => 'Error';

  @override
  String get searchHint => 'Search books...';

  @override
  String get all => 'All';

  @override
  String get mostRelevant => 'Most Relevant';

  @override
  String get fileNotExists => 'File does not exist';

  @override
  String get socketException => 'Network error';

  @override
  String get categories => 'Categories';

  @override
  String get myBooks => 'My Books';

  @override
  String get bookDetails => 'Book Details';

  @override
  String get author => 'Author';

  @override
  String get publisher => 'Publisher';

  @override
  String get year => 'Year';

  @override
  String get pages => 'Pages';

  @override
  String get size => 'Size';

  @override
  String get format => 'Format';

  @override
  String get download => 'Download';

  @override
  String get read => 'Read';

  @override
  String get delete => 'Delete';

  @override
  String get deleteBookConfirmation => 'Delete Book';

  @override
  String get deletionIsPermanent => 'This action is permanent and cannot be undone';

  @override
  String get bookDeletedSuccessfully => 'Book has been deleted';

  @override
  String get searchResult => 'Results';

  @override
  String get noResultFound => 'No Results Found!';

  @override
  String get myLibraryTitle => 'My Library';

  @override
  String get myLibraryIsEmptyMessage => 'Your library is empty';

  @override
  String get open => 'Open';

  @override
  String get retry => 'Retry';

  @override
  String get share => 'Share';

  @override
  String get description => 'Description';

  @override
  String get noDescription => 'No description available';

  @override
  String get searchByTitle => 'Search by title';

  @override
  String get searchByAuthor => 'Search by author';

  @override
  String get searchByPublisher => 'Search by publisher';

  @override
  String get sortBy => 'Sort by';

  @override
  String get relevance => 'Relevance';

  @override
  String get popularity => 'Popularity';

  @override
  String get newest => 'Newest';

  @override
  String get oldest => 'Oldest';

  @override
  String get bookNotFound => 'Book not found';

  @override
  String get networkError => 'Network error';

  @override
  String get tryAgain => 'Try again';

  @override
  String get storagePermission => 'Storage permission';

  @override
  String get storagePermissionMessage => 'Storage permission is required to download and save books';

  @override
  String get grantPermission => 'Grant permission';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get downloadInProgress => 'Download in progress...';

  @override
  String get downloadStarted => 'Download started';

  @override
  String get downloadCanceled => 'Download canceled';

  @override
  String get downloadPaused => 'Download paused';

  @override
  String get resume => 'Resume';

  @override
  String get pause => 'Pause';

  @override
  String get loading => 'Loading...';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get addBookmark => 'Add bookmark';

  @override
  String get removeBookmark => 'Remove bookmark';

  @override
  String get bookmarkAdded => 'Bookmark added';

  @override
  String get bookmarkRemoved => 'Bookmark removed';

  @override
  String get openPdfWithExternalApp => 'Open PDF with External App';

  @override
  String get openEpubWithExternalApp => 'Open EPUB with External App';

  @override
  String pageNumber(int number) {
    return 'Page $number';
  }

  @override
  String pageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get fontSize => 'Font size';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get scrollingSpeed => 'Scrolling speed';

  @override
  String get slow => 'Slow';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Fast';

  @override
  String get veryFast => 'Very fast';

  @override
  String get systemDefault => 'System default';

  @override
  String get genres => 'Genres';

  @override
  String get sciTech => 'Sci-Tech';

  @override
  String get popular => 'Popular';

  @override
  String get title => 'Title';

  @override
  String get extension => 'Extension';

  @override
  String get isbn => 'ISBN';

  @override
  String get ipfs => 'IPFS';

  @override
  String get md5 => 'MD5';

  @override
  String get aboutPageDescription => 'Megalib is an open source book search engine that allows you to search and download books from various sources.';

  @override
  String get version => 'Version';

  @override
  String get github => 'Github';

  @override
  String get openGithubPage => 'Open Github Page';

  @override
  String get contributeToMegalib => 'Contribute To Megalib';

  @override
  String get reportAnIssue => 'Report An Issue';

  @override
  String get licence => 'Licence';

  @override
  String get gplV30License => 'GPL v3.0 license';

  @override
  String get type => 'Type';

  @override
  String get fileType => 'File type';

  @override
  String get searchFieldEmpty => 'Search field is empty';

  @override
  String get couldNotOpenPdf => 'Could not open the PDF';

  @override
  String get couldNotLaunchUrl => 'Could not launch URL';

  @override
  String get unableToOpenFile => 'Unable to open file';

  @override
  String get unableToOpenEpub => 'Unable to open epub';

  @override
  String get bookDownloaded => 'Book has been downloaded!';

  @override
  String get noMirrorsAvailable => 'No mirrors available';

  @override
  String get checksumFailed => 'Checksum failed';

  @override
  String get checksumFailedWarning => 'The downloaded book may be malicious. Delete it and get the same book from another source, or use the book at your own risk.';

  @override
  String get addToLibrary => 'Add To My Library';

  @override
  String get solveCaptcha => 'Solve Captcha';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this book?';

  @override
  String get classics => 'Classics';

  @override
  String get romance => 'Romance';

  @override
  String get fiction => 'Fiction';

  @override
  String get youngAdult => 'Young Adult';

  @override
  String get fantasy => 'Fantasy';

  @override
  String get scienceFiction => 'Science Fiction';

  @override
  String get nonfiction => 'Nonfiction';

  @override
  String get children => 'Children';

  @override
  String get history => 'History';

  @override
  String get mystery => 'Mystery';

  @override
  String get covers => 'Covers';

  @override
  String get horror => 'Horror';

  @override
  String get historicalFiction => 'Historical Fiction';

  @override
  String get best => 'Best';

  @override
  String get titles => 'Titles';

  @override
  String get middleGrade => 'Middle Grade';

  @override
  String get paranormal => 'Paranormal';

  @override
  String get love => 'Love';

  @override
  String get queer => 'Queer';

  @override
  String get historicalRomance => 'Historical Romance';

  @override
  String get contemporary => 'Contemporary';

  @override
  String get thriller => 'Thriller';

  @override
  String get women => 'Women';

  @override
  String get biography => 'Biography';

  @override
  String get lgbtq => 'LGBTQ';

  @override
  String get series => 'Series';

  @override
  String get titleChallenge => 'Title Challenge';
}
