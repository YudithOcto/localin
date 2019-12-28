class ImageHelper {
  static String addSubFixHttp(String value) {
    if (value == null) return '';
    if (value.contains('http')) return '';
    return 'https://localin.sgp1.digitaloceanspaces.com/$value';
  }
}
