import 'dart:io';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/DandyToastUtil.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import 'SelectAPhotoActions.dart';
import 'SelectAPhotoPageState.dart';


class SelectAPhotoPage extends StatefulWidget {
  static const String ENGAGEMENT = "Engagement";
  static const String FAMILIES = "Families";
  static const String COUPLES = "Couples";
  static const String PORTRAITS = "Portraits";
  static const String MATERNITY = "Maternity";
  static const String WEDDINGS = "Weddings";
  static const String NEWBORN = "Newborn";
  static const String PROPOSALS = "Proposals";
  static const String PETS = "Pets";

  final Function(String) onImageSelected;

  const SelectAPhotoPage({Key key, this.onImageSelected}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectAPhotoPageState(onImageSelected);
  }
}

class _SelectAPhotoPageState extends State<SelectAPhotoPage> with TickerProviderStateMixin {
  final Function(String) onImageSelected;

  _SelectAPhotoPageState(this.onImageSelected);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, SelectAPhotoPageState>(
    onInit: (store) {
      store.dispatch(ClearSelectAPoseStateAction(store.state.selectAPhotoPageState));
      store.dispatch(LoadUploadedPhotosAction(store.state.selectAPhotoPageState));
    },
    converter: (Store<AppState> store) => SelectAPhotoPageState.fromStore(store),
    builder: (BuildContext context, SelectAPhotoPageState pageState) =>
         Scaffold(
           appBar: AppBar(
             iconTheme: IconThemeData(
               color: Color(ColorConstants.getPrimaryBlack())
             ),
             title: TextDandyLight(
               type: TextDandyLight.LARGE_TEXT,
               text: 'Select a Photo',
               textAlign: TextAlign.center,
               color: Color(ColorConstants.getPrimaryBlack()),
             ),
             actions: [
               GestureDetector(
                 onTap: () {
                    getDeviceImage();
                 },
                 child: Container(
                   alignment: Alignment.center,
                   padding: EdgeInsets.all(16),
                   height: 54,
                   child: Image.asset(
                     'assets/images/icons/file_upload.png',
                     color: Color(ColorConstants.getPrimaryBlack()),
                     width: 26,
                   ),
                 ),
               )
             ],
             backgroundColor: Color(ColorConstants.getPrimaryWhite()),
             elevation: 0,
           ),
           backgroundColor: Color(ColorConstants.getPrimaryWhite()),
           body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    height: 32,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'My uploads',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (_, index) => _buildItem(context, index, pageState),
                    itemCount: pageState.urls.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                  ),
                ],
              ),
           ),
         ),
    );

  Widget _buildItem(BuildContext context, int index, SelectAPhotoPageState pageState) {
    return GestureDetector(
      onTap: () {
        onImageSelected(pageState.urls.elementAt(index));
      },
      child: Container(
        padding: const EdgeInsets.only(left:0.5, right: 0.5, top: 1),
        child: DandyLightNetworkImage(
          pageState.urls.elementAt(index),
          resizeWidth: 350,
          borderRadius: 0,
        )
      ),
    );
  }

  Future getDeviceImage() async {
    try {
      XFile localImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      XFile localWebImage = XFile((await cropImageForWeb(localImage.path)).path);
      XFile localMobileImage = XFile((await cropImageForMobile(localImage.path)).path);

      if(localWebImage != null && localMobileImage != null && localImage != null) {
        pageState.onWebImageUploaded(localWebImage);
        pageState.onMobileImageUploaded(localMobileImage);

      } else {
        DandyToastUtil.showErrorToast('Image not loaded');
      }
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
      DandyToastUtil.showErrorToast('Image not loaded');
    }
  }

  Future<CroppedFile> cropImageForWeb(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      maxWidth: 1920,
      maxHeight: 664,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1.33),
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop to fit desktop',
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop to fit desktop',
          aspectRatioPickerButtonHidden: true,
          doneButtonTitle: 'Next',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
  }

  Future<CroppedFile> cropImageForMobile(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      maxWidth: 1080,
      maxHeight: 810,
      aspectRatio: const CropAspectRatio(ratioX: 1.33, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop to fit mobile',
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop to fit mobile',
          aspectRatioPickerButtonHidden: true,
          doneButtonTitle: 'Save',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
  }
}