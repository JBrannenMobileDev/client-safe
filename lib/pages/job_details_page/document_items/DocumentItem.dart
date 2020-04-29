import 'package:flutter/cupertino.dart';

abstract class DocumentItem {
  static const String DOCUMENT_TYPE_INVOICE = 'Invoice';
  static const String DOCUMENT_TYPE_CONTRACT = 'Contract';
  static const String DOCUMENT_TYPE_QUESTIONNAIRE = 'Questionnaire';
  static const String DOCUMENT_TYPE_FEEDBACK = 'Feedback';

  String getDocumentType();
  Widget buildTitle(BuildContext context);
  Widget buildIconItem(BuildContext context);
}