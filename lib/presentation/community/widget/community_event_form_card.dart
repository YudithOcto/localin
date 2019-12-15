import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/presentation/community/widget/community_event_form_date_time.dart';
import 'package:localin/presentation/community/widget/community_heading_title_widget.dart';

class CommunityEventFormCard extends StatefulWidget {
  @override
  _CommunityEventFormCardState createState() => _CommunityEventFormCardState();
}

class _CommunityEventFormCardState extends State<CommunityEventFormCard> {
  bool selectedFund = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CommunityHeadingTitleWidget('Judul Acara'),
          Container(
            height: 50.0,
            margin: EdgeInsets.only(bottom: 15.0),
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
          CommunityHeadingTitleWidget('Tema/Kategori Acara'),
          Container(
            height: 50.0,
            margin: EdgeInsets.only(bottom: 15.0),
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
          CommunityHeadingTitleWidget('Deskripsi'),
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
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
                    hintStyle: TextStyle(fontSize: 12.0, color: Colors.black45),
                    hintText:
                        'Deskripsikan komunitas anda untuk menjangkau pengikut'),
              ),
            ),
          ),
          CommunityHeadingTitleWidget('Durasi Acara'),
          CommunityEventFormDateTime(),
          CommunityHeadingTitleWidget('Tempat'),
          CommunityHeadingTitleWidget(
            'Alamat',
            textSize: 14.0,
            color: Colors.black54,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            height: 50.0,
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
                    hintStyle: TextStyle(fontSize: 12.0, color: Colors.black45),
                    hintText: 'Jln. Maulana Hasanudin'),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CommunityHeadingTitleWidget(
                      'Kecamatan',
                      textSize: 14.0,
                      color: Colors.black54,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      height: 50.0,
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
                              hintStyle: TextStyle(
                                  fontSize: 12.0, color: Colors.black45),
                              hintText: 'Jln. Maulana Hasanudin'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CommunityHeadingTitleWidget(
                      'Kota',
                      textSize: 14.0,
                      color: Colors.black54,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      height: 50.0,
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
                              hintStyle: TextStyle(
                                  fontSize: 12.0, color: Colors.black45),
                              hintText: 'Kota Tangerang'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          CommunityHeadingTitleWidget('Biaya'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedFund = false;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        selectedFund
                            ? Icons.radio_button_unchecked
                            : Icons.radio_button_checked,
                        size: 25.0,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text('Gratis'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedFund = true;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(!selectedFund
                              ? Icons.radio_button_unchecked
                              : Icons.radio_button_checked),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text('Berbayar'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 80.0,
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(bottom: 15.0),
                      height: 50.0,
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
                              hintStyle: TextStyle(
                                  fontSize: 12.0, color: Colors.black45),
                              hintText: 'Rp 80.000.00'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          CommunityHeadingTitleWidget('Tambahkan Foto/Video'),
          dashBorder(),
          SizedBox(
            height: 10.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            width: double.infinity,
            height: 50.0,
            child: RoundedButtonFill(
              onPressed: () {},
              needCenter: true,
              fontSize: 18.0,
              title: 'Buat Acara',
            ),
          ),
        ],
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
}
