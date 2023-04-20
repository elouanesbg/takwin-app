class DownloadService {
  static final DownloadService _singleton = DownloadService._internal();

  factory DownloadService() {
    return _singleton;
  }

  DownloadService._internal();
}
