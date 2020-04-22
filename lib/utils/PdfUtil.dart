import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfUtil {
  static Future<File> getPdfFile(int invoiceNumber) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/invoice_' + invoiceNumber.toString() + '.pdf';
    return File(path);
  }

  static savePdfFile(int invoiceNumber, Document pdf) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/invoice_' + invoiceNumber.toString() + '.pdf';
    await File(path).writeAsBytes(pdf.save());
  }

  static Future<String> getInvoiceFilePath(int invoiceNumber) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/invoice_' + invoiceNumber.toString() + '.pdf';
    return path;
  }
}