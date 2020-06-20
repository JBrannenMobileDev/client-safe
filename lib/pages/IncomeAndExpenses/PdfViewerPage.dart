import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  const PdfViewerPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(ColorConstants.getPrimaryWhite()), //change your color here
          ),
          backgroundColor: Color(ColorConstants.getPrimaryColor()),
          title: Text("Document",
            style: TextStyle(
            fontSize: 26.0,
            fontFamily: 'simple',
            fontWeight: FontWeight.w600,
            color: Color(ColorConstants.getPrimaryWhite()),
          ),),
        ),
        path: path
    );
  }
}