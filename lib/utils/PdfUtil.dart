import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:http/http.dart' show get;
import '../models/Branding.dart';
import '../models/Client.dart';
import '../models/Contract.dart';
import '../models/FontTheme.dart';
import '../models/Invoice.dart';
import '../models/Job.dart';
import '../models/LineItem.dart';
import '../models/Profile.dart';
import '../models/Proposal.dart';
import 'ColorConstants.dart';
import 'TextFormatterUtil.dart';

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
  static Future<Document> generateInvoicePdfFromInvoice(Invoice invoice, Job job, Client client, Profile profile, Branding branding) async {
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
    var response;
    var data;

    if(logoUrl != null) {
      response = await get(Uri.parse(logoUrl));
      data = response.bodyBytes;
    }

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

    String fontFamilyPath = FontTheme.getFilePath(profile.selectedFontTheme.bodyFont);
    bool makeTextBold = FontTheme.shouldUseBold(profile.selectedFontTheme.bodyFont);

    pdf.addPage(MultiPage(
        theme: ThemeData.withFont(
          base: Font.ttf(
              await rootBundle.load(fontFamilyPath)),
          bold:
              Font.ttf(await rootBundle.load(fontFamilyPath)),
          italic:
              Font.ttf(await rootBundle.load(fontFamilyPath)),
          boldItalic:
              Font.ttf(await rootBundle.load(fontFamilyPath)),
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
              child: Text(
                  profile.businessName + ' Invoice',
                  style: Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey, fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal)
              )
          );
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey,
                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal),
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
                              child: ClipRRect(
                                horizontalRadius: 37.5,
                                verticalRadius: 37.5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PdfColor.fromHex(logoColor),
                                  ),
                                  width: 150,
                                  height: 150,
                                  child: Image(MemoryImage(data),),
                                ),
                              )
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
                                profile.logoCharacter != null
                                    ? profile.logoCharacter
                                    : '',
                                style: Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(fontSize: 56, color: PdfColor.fromHex(logoTextColor),
                                    fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal)
                            ),
                          ),
                        ) : SizedBox(),
                        Text(
                            profile.businessName != null
                                ? profile.businessName
                                : 'Invoice',
                          style: Theme.of(context)
                              .defaultTextStyle
                              .copyWith(fontSize: 16, color: PdfColor.fromHex('#444444'), fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal)
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
                            color: PdfColor.fromHex('#444444'),
                            fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                        )),
                        Text(client.getClientFullName(),
                            textScaleFactor: 0.85),
                        client.phone != null
                            ? Text(client.phone.toString(),
                                textScaleFactor: 0.85, style: TextStyle(
                                color: PdfColor.fromHex('#444444'),
                                fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                            ))
                            : SizedBox(),
                        client.email != null
                            ? Text(client.email.toString(),
                                textScaleFactor: 0.85, style: TextStyle(
                                color: PdfColor.fromHex('#444444'),
                                fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                            ))
                            : SizedBox(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('Id: ' + invoiceNumber.toString(),
                            textScaleFactor: 0.85,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444'),
                                fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                            )),
                        depositDueDate != null
                            ? Text(
                                'Deposit due:  ' +
                                    DateFormat('MMM dd, yyyy')
                                        .format(dueDate),
                                textScaleFactor: 0.85,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444'),
                                fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                            ))
                            : SizedBox(),
                        dueDate != null
                            ? Text(
                            'Total due:  ' +
                                DateFormat('MMM dd, yyyy')
                                    .format(dueDate),
                            textScaleFactor: 0.85,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444'),
                                fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                color: PdfColor.fromHex('#444444'),
                                fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                    color: PdfColor.fromHex('#444444'),
                                    fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                                )
                            ),
                          ),
                          Container(
                            width: 96.0,
                            alignment: Alignment.centerRight,
                            child: Text('Price',
                                textScaleFactor: 0.85, textAlign: TextAlign.right, style: TextStyle(
                                    color: PdfColor.fromHex('#444444'),
                                    fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                    color: PdfColor.fromHex('#444444'),
                                    fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                  color: PdfColor.fromHex('#444444'),
                                  fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                      color: PdfColor.fromHex('#444444'),
                                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                      color: PdfColor.fromHex('#444444'),
                                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                      color: PdfColor.fromHex('#444444'),
                                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444'),
                              fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                          )
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 66.0,
                          alignment: Alignment.centerRight,
                          child: Text('',
                              textScaleFactor: 0.85, textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: PdfColor.fromHex('#444444'),
                                  fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                              )
                          ),
                        ),
                        Container(
                          width: 96.0,
                          alignment: Alignment.centerRight,
                          child: Text('Subtotal',
                              textScaleFactor: 0.85, textAlign: TextAlign.right, style: TextStyle(
                                  color: PdfColor.fromHex('#444444'),
                                  fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                  color: PdfColor.fromHex('#444444'),
                                  fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                              style: TextStyle(
                                  color: PdfColor.fromHex('#444444'),
                                  fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                              )
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
                                      color: PdfColor.fromHex('#444444'),
                                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                                  )
                              ),
                            ),
                            Container(
                              width: 100.0,
                              alignment: Alignment.centerRight,
                              child: Text('Discount',
                                  textScaleFactor: 0.85,
                                  textAlign: TextAlign.right, style: TextStyle(
                                      color: PdfColor.fromHex('#444444'),
                                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                      color: PdfColor.fromHex('#444444'),
                                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                              style: TextStyle(
                                  color: PdfColor.fromHex('#444444'),
                                  fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                              )
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
                                      color: PdfColor.fromHex('#444444'),
                                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                                  )),
                            ),
                            Container(
                              width: 96.0,
                              alignment: Alignment.centerRight,
                              child: Text('Sales tax',
                                  textScaleFactor: 0.85,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: PdfColor.fromHex('#444444'),
                                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                      color: PdfColor.fromHex('#444444'),
                                      fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
          depositValue > 0 ? Row(
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
                            color: PdfColor.fromHex('#444444'),
                            fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                        )),
                  ),
                  Container(
                    width: 120.0,
                    alignment: Alignment.centerRight,
                    child: Text('Retainer' + (depositPaid ? '(Paid)' : '(Unpaid)'),
                        textScaleFactor: 0.85, textAlign: TextAlign.right,
                        style: TextStyle(
                            color: PdfColor.fromHex('#444444'),
                            fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                            color: PdfColor.fromHex('#444444'),
                            fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                        )
                    ),
                  ),
                ],
              ),
            ],
          ) : SizedBox(),
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
                        style: TextStyle(
                            color: PdfColor.fromHex('#444444'),
                            fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                        )
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
                                color: PdfColor.fromHex('#444444'),
                                fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                            )
                        ),
                      ),
                      Container(
                        width: 120.0,
                        alignment: Alignment.centerRight,
                        child: Text('Balance due',
                            textScaleFactor: 0.85, textAlign: TextAlign.right,
                            style: TextStyle(
                                color: PdfColor.fromHex('#444444'),
                                fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                                color: PdfColor.fromHex('#444444'),
                                fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
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
                              color: PdfColor.fromHex('#444444'),
                              fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                          )),
                    )
                  : SizedBox(),
              zelleInfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(zelleInfo,
                          textScaleFactor: 0.85, textAlign: TextAlign.left,
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444'),
                              fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                          )),
                    )
                  : SizedBox(),
              venmoInfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(venmoInfo,
                          textScaleFactor: 0.85, textAlign: TextAlign.left,
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444'),
                              fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                          )),
                    )
                  : SizedBox(),
              cashAppInfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(cashAppInfo,
                          textScaleFactor: 0.85, textAlign: TextAlign.left,
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444'),
                              fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                          )),
                    )
                  : SizedBox(),
              applePayInfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(applePayInfo,
                          textScaleFactor: 0.85, textAlign: TextAlign.left,
                          style: TextStyle(
                              color: PdfColor.fromHex('#444444'),
                              fontWeight: makeTextBold ? FontWeight.bold : FontWeight.normal
                          )),
                    )
                  : SizedBox(),
            ]));

    return pdf;
  }

  static Future<Document> generateContract(Contract contract, Proposal proposal, Profile profile, Job job) async {
    final Document pdf = Document();
    final signatureFont = Font.ttf(await rootBundle.load('assets/fonts/sig.ttf'));

    pdf.addPage(MultiPage(
        theme: ThemeData.withFont(
          base: Font.ttf(
              await rootBundle.load('assets/fonts/OpenSans-VariableFont_wdth,wght.ttf')),
          bold:
          Font.ttf(await rootBundle.load('assets/fonts/OpenSans-VariableFont_wdth,wght.ttf')),
          italic:
          Font.ttf(await rootBundle.load('assets/fonts/signature.ttf')),
          boldItalic:
          Font.ttf(await rootBundle.load('assets/fonts/OpenSans-VariableFont_wdth,wght.ttf')),
        ),
        pageFormat:
        PdfPageFormat.letter.copyWith(marginBottom: 1 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return SizedBox();
          }
          return Container(
              alignment: Alignment.centerLeft,
              // margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              child: Text('Client Service Agreement',
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
        build: (Context context) {
          List<String> paragraphs = contract.terms.split('\n\n');
          List<Widget> termsParagraphs = [];
          termsParagraphs.add(
            Header(
              level: 2,
              child: Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(bottom: 16),
                child: Text(
                    'Client Service Agreement',
                    textAlign: TextAlign.center,
                    style: Theme
                        .of(context)
                        .defaultTextStyle
                        .copyWith(
                        fontSize: 16, color: PdfColor.fromHex('#444444'))
                ),
              ),
            ),
          );
          paragraphs.forEach((paragraph) {
            termsParagraphs.add(
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                      paragraph,
                      textScaleFactor: .85,
                      style: TextStyle(
                          color: PdfColor.fromHex('#444444')
                      ),
                      overflow: TextOverflow.span
                  )
                ));
          });
          termsParagraphs.add(
              Container(
              margin: EdgeInsets.only(top: 32, bottom: 32),
              child: Text(
                  'I acknowledge that I have read and understood the contents of this agreement, and I hereby agree to all the terms and conditions outlined within it by signing this document.',
                  textScaleFactor: .85,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColor.fromHex('#444444'),
                  ),
                  overflow: TextOverflow.span
              )
          ));
          termsParagraphs.add(Row(
            children: [
              Container(
                width: 224,
                margin: EdgeInsets.only(bottom: 64, right: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 4),
                          child: Text(
                              'Date: ',
                              textScaleFactor: .85,
                              style: TextStyle(
                                color: PdfColor.fromHex('#444444'),
                              ),
                              overflow: TextOverflow.span
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 4),
                          child: Text(
                              DateFormat('EEE, MMMM dd, yyyy').format(contract.photographerSignedDate),
                              textScaleFactor: .85,
                              style: TextStyle(
                                color: PdfColor.fromHex('#444444'),
                              ),
                              overflow: TextOverflow.span
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 4),
                          child: Text(
                            'Photographer Name: ',
                              textScaleFactor: .85,
                            style: TextStyle(
                            )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 4),
                          child: Text(
                            profile.firstName + ' ' + profile.lastName,
                            textScaleFactor: .85,
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Photographer Signature:',
                          textScaleFactor: .85,
                        style: TextStyle(
                        )
                      ),
                    ),
                    Container(
                      child: Text(
                          contract.signedByClient ? (profile.firstName + ' ' + profile.lastName) : '',
                          textScaleFactor: .85,
                          style: TextStyle(
                            font: signatureFont,
                            fontSize: 32,
                          )
                      ),
                    ),
                    Container(
                      height: 0.5,
                      width: 224,
                      color: PdfColor.fromHex('#444444'),
                    )
                  ],
                ),
              ),
              Container(
                width: 224,
                margin: EdgeInsets.only(bottom: 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 4),
                          child: Text(
                            'Date: ',
                              textScaleFactor: .85,
                            style: TextStyle(
                            )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 4),
                          child: Text(
                            DateFormat('EEE, MMMM dd, yyyy').format(proposal.contract.clientSignedDate != null ? proposal.contract.clientSignedDate : DateTime.now()),
                            textScaleFactor: .85,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 4),
                          child: Text(
                            'Client Name: ',
                              textScaleFactor: .85,
                            style: TextStyle(
                            )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 4),
                          child: Text(
                            job.client.getClientFullName(),
                            textScaleFactor: .85,
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Client Signature:',
                          textScaleFactor: .85,
                        style: TextStyle(
                        )
                      ),
                    ),
                    Container(
                      child: Text(
                          proposal.contract.signedByClient ? contract.clientSignature : '',
                          textScaleFactor: .85,
                          style: TextStyle(
                            font: signatureFont,
                            fontSize: 32,
                          )
                      )
                    ),
                    Container(
                      height: 0.5,
                      width: 224,
                      color: PdfColor.fromHex('#444444'),
                    )
                  ],
                ),
              )
            ]
          ));
          return termsParagraphs;
        })
    );

    return pdf;
  }
}
