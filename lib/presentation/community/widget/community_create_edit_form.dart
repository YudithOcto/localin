import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';

class CommunityCreateEditForm extends StatefulWidget {
  final bool isUpdatePage;

  CommunityCreateEditForm({@required this.isUpdatePage});
  @override
  _CommunityCreateEditFormState createState() =>
      _CommunityCreateEditFormState();
}

class _CommunityCreateEditFormState extends State<CommunityCreateEditForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidate: autoValidate,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title('Nama Komunitas'),
            SizedBox(
              height: 15.0,
            ),
            Container(
              height: 50.0,
              child: TextFormField(
                onSaved: (value) {},
                validator: (value) =>
                    value.isEmpty ? 'Nama Komunitas di butuhkan' : null,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12.0, color: Colors.black45),
                    hintText: 'Beri nama komunitas anda',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            title('Kategori'),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 50.0,
              child: TextFormField(
                onSaved: (value) {},
                validator: (value) =>
                    value.isEmpty ? 'Kategori di butuhkan' : null,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12.0, color: Colors.black45),
                    hintText: 'Contoh: IT, Otomotif, Seni dsb',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            title('Deskripsi'),
            SizedBox(
              height: 15.0,
            ),
            Container(
              height: 120.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black26)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (value) {},
                  validator: (value) =>
                      value.isEmpty ? 'Deskripsi di butuhkan' : null,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle:
                          TextStyle(fontSize: 12.0, color: Colors.black45),
                      hintText:
                          'Deskripsikan komunitas anda untuk menjangkau pengikut'),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            title('Logo'),
            SizedBox(
              height: 15.0,
            ),
            dashBorder(),
            SizedBox(
              height: 15.0,
            ),
            title('Sampul'),
            SizedBox(
              height: 15.0,
            ),
            Visibility(
              visible: widget.isUpdatePage,
              child: dashBorderBig(),
            ),
            Visibility(
              visible: widget.isUpdatePage,
              child: SizedBox(
                height: 15.0,
              ),
            ),
            Container(
              width: double.infinity,
              height: 50.0,
              child: RoundedButtonFill(
                onPressed: () {},
                needCenter: true,
                fontSize: 18.0,
                title: widget.isUpdatePage ? 'Simpan' : 'Buat Komunitas',
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget title(String value) {
    return Text(
      '$value',
      style: kValueStyle.copyWith(
          fontWeight: FontWeight.w500,
          color: Themes.primaryBlue,
          fontSize: 16.0),
    );
  }

  Widget dashBorderBig() {
    return Container(
      height: 180.0,
      width: double.infinity,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        dashPattern: <double>[5, 5],
        color: Colors.black26,
        padding: EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Center(
            child: Icon(
              Icons.photo_camera,
              size: 50.0,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget dashBorder() {
    return Container(
      alignment: Alignment.center,
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: <double>[5, 5],
        color: Colors.black26,
        radius: Radius.circular(12),
        padding: EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.photo_camera,
                  size: 50.0,
                  color: Colors.grey,
                ),
                Text(
                  'Drop files here',
                  style: TextStyle(fontSize: 12.0, color: Colors.black38),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateInput() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();

      /// go to other page
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }
}
