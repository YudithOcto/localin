import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_place/google_place.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/debounce.dart';
import 'package:localin/utils/location_helper.dart';

class SearchGooglePage extends StatefulWidget {
  static const routeName = 'SearchGooglePage';

  @override
  _SearchGooglePageState createState() => _SearchGooglePageState();
}

class _SearchGooglePageState extends State<SearchGooglePage> {
  GooglePlace googlePlace;
  Debounce _debounce;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    googlePlace = GooglePlace(kGoogleApiKey);
    _debounce = Debounce(milliseconds: 400);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.black0,
          titleSpacing: 0.0,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: ThemeColors.black80,
            ),
          ),
          title: Container(
            height: 43.0,
            margin: EdgeInsets.only(right: 20.0),
            child: TextFormField(
              onChanged: (value) async {
                if (value.isNotEmpty) {
                  _debounce.run(() => autoCompleteSearch(value));
                } else {
                  if (predictions.length > 0 && mounted) {
                    setState(() {
                      predictions = [];
                    });
                  }
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: ThemeColors.black10,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(color: ThemeColors.black0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(color: ThemeColors.black0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(color: ThemeColors.black0)),
                hintText: 'Search Location',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                hintStyle: ThemeText.sfRegularBody
                    .copyWith(color: ThemeColors.black60),
              ),
            ),
          ),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 20.0),
          physics: ClampingScrollPhysics(),
          itemCount: predictions.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).pop(predictions[index]);
              },
              leading: SvgPicture.asset(
                'images/add_location.svg',
                width: 48.0,
                height: 48.0,
              ),
              title: Text(
                predictions[index].description,
                style: ThemeText.rodinaHeadline,
              ),
              subtitle: Text(
                'City',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
            );
          },
        ));
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }
}
