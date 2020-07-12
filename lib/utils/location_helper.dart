const kGoogleApiKey = 'AIzaSyCcpXmCiUxhtk1EcTJ3g9HxVDNYQx9X8Mk';

class LocationHelper {
  static String generateLocationPreviewImage(
      double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&'
        'zoom=13&size=600x500&maptype=roadmap&LOC%7C$latitude,$longitude&key=$kGoogleApiKey';
  }
}
