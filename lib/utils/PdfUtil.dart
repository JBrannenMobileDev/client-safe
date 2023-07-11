import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../data_layer/local_db/daos/ClientDao.dart';
import '../data_layer/local_db/daos/JobDao.dart';
import '../data_layer/local_db/daos/ProfileDao.dart';
import '../models/Branding.dart';
import '../models/Client.dart';
import '../models/Invoice.dart';
import '../models/Job.dart';
import '../models/JobStage.dart';
import '../models/LineItem.dart';
import '../models/Profile.dart';
import '../pages/new_invoice_page/NewInvoicePageState.dart';
import 'Shadows.dart';
import 'TextFormatterUtil.dart';
import 'UidUtil.dart';

class PdfUtil {
  /**
   * the following methods are for mobile app
   */
  static Future<File> getPdfFile(int invoiceNumber) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/invoice_' + invoiceNumber.toString() + '.pdf';
    return File(path);
  }

  static savePdfFile(int invoiceNumber, Document pdf) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/invoice_' + invoiceNumber.toString() + '.pdf';
    await File(path).writeAsBytes(List.from(await pdf.save()));
  }

  static Future<String> getInvoiceFilePath(int invoiceNumber) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/invoice_' + invoiceNumber.toString() + '.pdf';
    return path;
  }

  /**
   * The following methods are for web app
   */
  static Future<Document> generateInvoicePdfFromInvoice(Invoice invoice, Job job, Client client, Profile profile, String logoUrl, Branding branding) async {
    return await generateInvoice(
        job,
        client,
        profile,
        invoice.invoiceId,
        invoice.dueDate,
        invoice.depositDueDate,
        invoice.lineItems,
        invoice.total,
        invoice.subtotal,
        invoice.depositAmount,
        invoice.discount,
        invoice.salesTaxRate,
        invoice.unpaidAmount,
        invoice.depositPaid,
        branding.logoUrl,
        branding.logoColor,
        branding.logoTextColor,
    );
  }

  static Future<Document> generateInvoice(
      Job job,
      Client client,
      Profile profile,
      int invoiceNumber,
      DateTime dueDate,
      DateTime depositDueDate,
      List<LineItem> lineItems,
      double total,
      double subtotal,
      double depositValue,
      double discountValue,
      double salesTaxPercent,
      double unpaidAmount,
      bool depositPaid,
      String logoUrl,
      String logoColor,
      String logoTextColor,
  ) async {
    final logoImage = await networkImage('https://www.nfet.net/nfet.jpg');
    String zelleInfo = profile.zellePhoneEmail != null && profile.zellePhoneEmail.isNotEmpty
            ? 'Zelle\n' +
                'Recipient info:\n' +
                (TextFormatterUtil.isEmail(profile.zellePhoneEmail)
                    ? 'Email: '
                    : TextFormatterUtil.isPhone(profile.zellePhoneEmail)
                        ? 'Phone: '
                        : 'Phone or Email') +
                TextFormatterUtil.formatPhoneOrEmail(profile.zellePhoneEmail) +
                '\nName: ' +
                profile.zelleFullName
            : '';
    String venmoInfo = profile.venmoLink != null && profile.venmoLink.isNotEmpty
        ? 'Venmo\n' + profile.venmoLink
        : '';
    String cashAppInfo =
        profile.cashAppLink != null && profile.cashAppLink.isNotEmpty
            ? 'Cash App\n' + profile.cashAppLink
            : '';
    String applePayInfo =
        profile.applePayPhone != null && profile.applePayPhone.isNotEmpty
            ? 'Apple Pay\n' +
                TextFormatterUtil.formatPhoneNum(profile.applePayPhone)
            : '';

    final Document pdf = Document();

    pdf.addPage(MultiPage(
        theme: ThemeData.withFont(
          base: Font.ttf(
              await rootBundle.load('assets/fonts/OpenSans.ttf')),
          bold:
              Font.ttf(await rootBundle.load('assets/fonts/OpenSans.ttf')),
          italic:
              Font.ttf(await rootBundle.load('assets/fonts/OpenSans.ttf')),
          boldItalic:
              Font.ttf(await rootBundle.load('assets/fonts/OpenSans.ttf')),
        ),
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return SizedBox();
          }
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: BoxDecoration(border: Border.all()),
              child: Text(profile.businessName + ' Invoice',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey),
              ));
        },
        build: (Context context) => <Widget>[
              Header(
                  level: 2,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        logoUrl != null ? Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 75,
                              width: 75,
                              child: Image(logoImage)
                            ),
                        ) : SizedBox(),
                        logoUrl == null ? Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Container(
                            alignment: Alignment.center,
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PdfColor.fromHex(logoColor)
                            ),
                            child: Text(
                                profile.businessName != null
                                    ? profile.businessName.substring(0,1)
                                    : 'I',
                                style: Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(fontSize: 56, color: PdfColor.fromHex(logoTextColor))
                            ),
                          ),
                        ) : SizedBox(),
                        Text(
                            profile.businessName != null
                                ? profile.businessName
                                : 'Invoice',
                          style: Theme.of(context)
                              .defaultTextStyle
                              .copyWith(fontSize: 16, color: PdfColor.fromHex('#444444'))
                        ),
                      ])),
              Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Invoice for', textScaleFactor: .85, style: TextStyle(
                            color: PdfColor.fromHex('#444444')
                        )),
                        Text(client.getClientFullName(),
                            textScaleFactor: 0.85),
                        client.phone != null
                            ? Text(client.phone.toString(),
                                textScaleFactor: 0.85)
                            : SizedBox(),
                        client.email != null
                            ? Text(client.email.toString(),
                                textScaleFactor: 0.85)
                            : SizedBox(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('Id: ' + invoiceNumber.toString(),
                            textScaleFactor: 0.85,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444')
                            )),
                        depositDueDate != null
                            ? Text(
                                'Deposit due:  ' +
                                    DateFormat('MMM dd, yyyy')
                                        .format(dueDate),
                                textScaleFactor: 0.85,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444')
                            ))
                            : SizedBox(),
                        dueDate != null
                            ? Text(
                            'Total due:  ' +
                                DateFormat('MMM dd, yyyy')
                                    .format(dueDate),
                            textScaleFactor: 0.85,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444')
                            ))
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 64),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: PdfColor.fromHex('#e3e1da'),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 194.0,
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Item',
                            textScaleFactor: 0.85,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444')
                            )
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 66.0,
                            alignment: Alignment.centerRight,
                            child: Text('Quantity',
                                textScaleFactor: 0.85,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: PdfColor.fromHex('#444444')
                                )
                            ),
                          ),
                          Container(
                            width: 96.0,
                            alignment: Alignment.centerRight,
                            child: Text('Price',
                                textScaleFactor: 0.85, textAlign: TextAlign.right, style: TextStyle(
                                    color: PdfColor.fromHex('#444444')
                                )),
                          ),
                          Container(
                            width: 96.0,
                            alignment: Alignment.centerRight,
                            child: Text(
                                'Amount',
                                textScaleFactor: 0.85,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: PdfColor.fromHex('#444444')
                                )
                            ),
                          ),
                        ],
                      ),
                    ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.builder(
                      itemCount: lineItems.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 246.0,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            lineItems.elementAt(index).itemName,
                            textScaleFactor: 0.85,
                            textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: PdfColor.fromHex('#444444')
                              )
                          ),
                        );
                      },
                    ),
                    Row(
                      children: <Widget>[
                        ListView.builder(
                          itemCount: lineItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 14.0,
                              alignment: Alignment.centerRight,
                              child: Text(
                                  lineItems
                                      .elementAt(index)
                                      .itemQuantity
                                      .toString(),
                                  textScaleFactor: 0.85,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: PdfColor.fromHex('#444444')
                                  )),
                            );
                          },
                        ),
                        ListView.builder(
                          itemCount: lineItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 96.0,
                              alignment: Alignment.centerRight,
                              child: Text(
                                  '\$' +
                                      lineItems
                                          .elementAt(index)
                                          .itemPrice
                                          .toString(),
                                  textScaleFactor: 0.85,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: PdfColor.fromHex('#444444')
                                  )),
                            );
                          },
                        ),
                        ListView.builder(
                          itemCount: lineItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 96.0,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '\$' +
                                    lineItems
                                        .elementAt(index)
                                        .getTotal()
                                        .toString(),
                                textScaleFactor: 0.85,
                                textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: PdfColor.fromHex('#444444')
                                  )
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Container(
                    height: 0.5,
                    width: 468.0,
                    color: PdfColor.fromHex('#e3e1da'),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 194.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '',
                        textScaleFactor: 0.85,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 66.0,
                          alignment: Alignment.centerRight,
                          child: Text('',
                              textScaleFactor: 0.85, textAlign: TextAlign.right),
                        ),
                        Container(
                          width: 96.0,
                          alignment: Alignment.centerRight,
                          child: Text('Subtotal',
                              textScaleFactor: 0.85, textAlign: TextAlign.right, style: TextStyle(
                                  color: PdfColor.fromHex('#444444')
                              )),
                        ),
                        Container(
                          width: 96.0,
                          alignment: Alignment.centerRight,
                          child: Text(
                              TextFormatterUtil.formatDecimalCurrency(subtotal),
                              textScaleFactor: 0.85,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: PdfColor.fromHex('#444444')
                              )
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              discountValue > 0
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 194.0,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '',
                            textScaleFactor: 0.85,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 70.0,
                              alignment: Alignment.centerRight,
                              child: Text('',
                                  textScaleFactor: 0.85,
                                  textAlign: TextAlign.right),
                            ),
                            Container(
                              width: 100.0,
                              alignment: Alignment.centerRight,
                              child: Text('Discount',
                                  textScaleFactor: 0.85,
                                  textAlign: TextAlign.right, style: TextStyle(
                                      color: PdfColor.fromHex('#444444')
                                  )),
                            ),
                            Container(
                              width: 96.0,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '-' + TextFormatterUtil.formatDecimalCurrency(discountValue),
                                textScaleFactor: 0.85,
                                textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: PdfColor.fromHex('#444444')
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(),
              salesTaxPercent > 0
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 198.0,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '',
                            textScaleFactor: 0.85,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 70.0,
                              alignment: Alignment.centerRight,
                              child: Text('',
                                  textScaleFactor: 0.85,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: PdfColor.fromHex('#444444')
                                  )),
                            ),
                            Container(
                              width: 96.0,
                              alignment: Alignment.centerRight,
                              child: Text('Sales tax',
                                  textScaleFactor: 0.85,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: PdfColor.fromHex('#444444')
                                  )),
                            ),
                            Container(
                              width: 96.0,
                              alignment: Alignment.centerRight,
                              child: Text(
                                TextFormatterUtil.formatDecimalDigitsCurrency(
                                    (total * (salesTaxPercent / 100)), 2),
                                textScaleFactor: 0.85,
                                textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: PdfColor.fromHex('#444444')
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(),
              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Container(
                        height: 0.0,
                        width: 263.0,
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Container(
                        height: 0.5,
                        width: 205.0,
                        color: PdfColor.fromHex('#e3e1da'),
                      )),
                ],
              ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 194.0,
                alignment: Alignment.centerLeft,
                child: Text(
                  '',
                  textScaleFactor: 0.85,
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 50.0,
                    alignment: Alignment.centerRight,
                    child: Text('',
                        textScaleFactor: 0.85, textAlign: TextAlign.right,
                        style: TextStyle(
                            color: PdfColor.fromHex('#444444')
                        )),
                  ),
                  Container(
                    width: 120.0,
                    alignment: Alignment.centerRight,
                    child: Text('Retainer' + (depositPaid ? '(Paid)' : '(Unpaid)'),
                        textScaleFactor: 0.85, textAlign: TextAlign.right,
                        style: TextStyle(
                            color: PdfColor.fromHex('#444444')
                        )),
                  ),
                  Container(
                    width: 96.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                      (depositPaid ? '-' : '') + TextFormatterUtil.formatDecimalCurrency(depositValue),
                      textScaleFactor: 0.85,
                      textAlign: TextAlign.right,
                        style: TextStyle(
                            color: PdfColor.fromHex('#444444')
                        )
                    ),
                  ),
                ],
              ),
            ],
          ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 194.0,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '',
                      textScaleFactor: 0.85,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        alignment: Alignment.centerRight,
                        child: Text('',
                            textScaleFactor: 0.85, textAlign: TextAlign.right),
                      ),
                      Container(
                        width: 120.0,
                        alignment: Alignment.centerRight,
                        child: Text('Balance due',
                            textScaleFactor: 0.85, textAlign: TextAlign.right,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444')
                            )),
                      ),
                      Container(
                        width: 96.0,
                        alignment: Alignment.centerRight,
                        child: Text(
                          TextFormatterUtil.formatDecimalCurrency(unpaidAmount),
                          textScaleFactor: 0.85,
                          textAlign: TextAlign.right,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444')
                            )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              zelleInfo.isNotEmpty ||
                      venmoInfo.isNotEmpty ||
                      cashAppInfo.isNotEmpty ||
                      applePayInfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 32.0),
                      child: Text('Accepted forms of payment',
                          textScaleFactor: 0.85, textAlign: TextAlign.left,
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444')
                          )),
                    )
                  : SizedBox(),
              zelleInfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(zelleInfo,
                          textScaleFactor: 0.85, textAlign: TextAlign.left,
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444')
                          )),
                    )
                  : SizedBox(),
              venmoInfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(venmoInfo,
                          textScaleFactor: 0.85, textAlign: TextAlign.left,
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444')
                          )),
                    )
                  : SizedBox(),
              cashAppInfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(cashAppInfo,
                          textScaleFactor: 0.85, textAlign: TextAlign.left,
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444')
                          )),
                    )
                  : SizedBox(),
              applePayInfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(applePayInfo,
                          textScaleFactor: 0.85, textAlign: TextAlign.left,
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444')
                          )),
                    )
                  : SizedBox(),
            ]));

    return pdf;
  }
}
