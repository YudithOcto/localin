const kGoogleApiKey = 'AIzaSyDSMoJYaboHxFynVBo8t6G-3vyIQpQNlKs';

class LocationHelper {
  static String generateLocationPreviewImage(
      double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&'
        'zoom=13&size=600x500&maptype=roadmap&markers=color:red%7Clabel:LOC%7C$latitude,'
        '$longitude&key=$kGoogleApiKey';
  }
}
