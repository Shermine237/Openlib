// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Openlib';

  @override
  String get home => 'Accueil';

  @override
  String get search => 'Rechercher';

  @override
  String get myLibrary => 'Ma Bibliothèque';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get about => 'À propos';

  @override
  String get trending => 'Tendances';

  @override
  String get errorLoading => 'Erreur de chargement du contenu';

  @override
  String get noBooks => 'Aucun livre trouvé';

  @override
  String get downloadComplete => 'Téléchargement terminé';

  @override
  String get downloadError => 'Erreur de téléchargement';

  @override
  String get openWith => 'Ouvrir avec';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get changeStoragePath => 'Changer le dossier de stockage';

  @override
  String get errorLoadingEpub => 'Erreur de chargement du fichier epub';

  @override
  String get error => 'Erreur';

  @override
  String get searchHint => 'Rechercher des livres...';

  @override
  String get all => 'Tous';

  @override
  String get mostRelevant => 'Plus Pertinent';

  @override
  String get fileNotExists => 'Le fichier n\'existe pas';

  @override
  String get socketException => 'Erreur réseau';

  @override
  String get categories => 'Catégories';

  @override
  String get myBooks => 'Mes Livres';

  @override
  String get bookDetails => 'Détails du livre';

  @override
  String get author => 'Auteur';

  @override
  String get publisher => 'Éditeur';

  @override
  String get year => 'Année';

  @override
  String get pages => 'Pages';

  @override
  String get size => 'Taille';

  @override
  String get format => 'Format';

  @override
  String get download => 'Télécharger';

  @override
  String get read => 'Lire';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteConfirmation => 'Êtes-vous sûr de vouloir supprimer ce livre ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get share => 'Partager';

  @override
  String get description => 'Description';

  @override
  String get noDescription => 'Aucune description disponible';

  @override
  String get searchByTitle => 'Rechercher par titre';

  @override
  String get searchByAuthor => 'Rechercher par auteur';

  @override
  String get searchByPublisher => 'Rechercher par éditeur';

  @override
  String get sortBy => 'Trier par';

  @override
  String get relevance => 'Pertinence';

  @override
  String get popularity => 'Popularité';

  @override
  String get newest => 'Plus récent';

  @override
  String get oldest => 'Plus ancien';

  @override
  String get bookNotFound => 'Livre introuvable';

  @override
  String get networkError => 'Erreur de connexion';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get storagePermission => 'Permission de stockage';

  @override
  String get storagePermissionMessage => 'La permission de stockage est nécessaire pour télécharger et sauvegarder les livres';

  @override
  String get grantPermission => 'Accorder la permission';

  @override
  String get permissionDenied => 'Permission refusée';

  @override
  String get downloadInProgress => 'Téléchargement en cours...';

  @override
  String get downloadStarted => 'Téléchargement démarré';

  @override
  String get downloadCanceled => 'Téléchargement annulé';

  @override
  String get downloadPaused => 'Téléchargement en pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get pause => 'Pause';

  @override
  String get loading => 'Chargement...';

  @override
  String get bookmarks => 'Marque-pages';

  @override
  String get addBookmark => 'Ajouter un marque-page';

  @override
  String get removeBookmark => 'Supprimer le marque-page';

  @override
  String get bookmarkAdded => 'Marque-page ajouté';

  @override
  String get bookmarkRemoved => 'Marque-page supprimé';

  @override
  String get openPdfWithExternalApp => 'Ouvrir les PDF avec une application externe';

  @override
  String get openEpubWithExternalApp => 'Ouvrir les EPUB avec une application externe';

  @override
  String pageNumber(int number) {
    return 'Page $number';
  }

  @override
  String pageOf(int current, int total) {
    return 'Page $current sur $total';
  }

  @override
  String get fontSize => 'Taille de police';

  @override
  String get small => 'Petite';

  @override
  String get medium => 'Moyenne';

  @override
  String get large => 'Grande';

  @override
  String get scrollingSpeed => 'Vitesse de défilement';

  @override
  String get slow => 'Lente';

  @override
  String get normal => 'Normale';

  @override
  String get fast => 'Rapide';

  @override
  String get veryFast => 'Très rapide';

  @override
  String get systemDefault => 'Système par défaut';

  @override
  String get genres => 'Genres';

  @override
  String get fiction => 'Fiction';

  @override
  String get sciTech => 'Science-Tech';

  @override
  String get popular => 'Populaire';

  @override
  String get title => 'Titre';

  @override
  String get extension => 'Extension';

  @override
  String get isbn => 'ISBN';

  @override
  String get ipfs => 'IPFS';

  @override
  String get md5 => 'MD5';

  @override
  String get open => 'Ouvrir';

  @override
  String get noResults => 'Aucun résultat trouvé';

  @override
  String get retry => 'Réessayer';

  @override
  String get aboutPageDescription => 'Megalib est un moteur de recherche de livres open source qui vous permet de rechercher et de télécharger des livres à partir de différentes sources.';

  @override
  String get version => 'Version';

  @override
  String get github => 'Github';

  @override
  String get openGithubPage => 'Ouvrir la page Github';

  @override
  String get contributeToMegalib => 'Contribuer à Megalib';

  @override
  String get reportAnIssue => 'Signaler un problème';

  @override
  String get licence => 'Licence';

  @override
  String get gplV30License => 'Licence GPL v3.0';

  @override
  String get type => 'Type';

  @override
  String get fileType => 'Type de fichier';

  @override
  String get searchFieldEmpty => 'Le champ de recherche est vide';

  @override
  String get couldNotOpenPdf => 'Impossible d\'ouvrir le PDF';

  @override
  String get couldNotLaunchUrl => 'Impossible d\'ouvrir l\'URL';

  @override
  String get unableToOpenFile => 'Impossible d\'ouvrir le fichier';

  @override
  String get unableToOpenEpub => 'Impossible d\'ouvrir l\'epub';

  @override
  String get bookDownloaded => 'Le livre a été téléchargé !';

  @override
  String get noMirrorsAvailable => 'Aucun miroir disponible';

  @override
  String get checksumFailed => 'La vérification a échoué';

  @override
  String get checksumFailedWarning => 'Le livre téléchargé peut être malveillant. Supprimez-le et téléchargez le même livre depuis une autre source, ou utilisez-le à vos risques et périls.';

  @override
  String get addToLibrary => 'Ajouter à ma bibliothèque';

  @override
  String get solveCaptcha => 'Résoudre le Captcha';
}
