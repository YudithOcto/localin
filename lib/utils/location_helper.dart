const kGoogleApiKey = 'AIzaSyCcpXmCiUxhtk1EcTJ3g9HxVDNYQx9X8Mk';

class LocationHelper {
  static String generateLocationPreviewImage(
      double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&'
        'zoom=13&size=600x500&maptype=roadmap&markers=icon:https://s3.amazonaws.com/loket-sandbox/images/banner/20190826130546_5d6376ba2de65.jpg&LOC%7C$latitude,$longitude&key=$kGoogleApiKey';
  }
}
