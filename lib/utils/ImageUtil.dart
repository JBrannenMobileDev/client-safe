import 'dart:io';
import 'dart:math';
import 'package:dandylight/data_layer/repositories/FileStorage.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/utils/PlatformInfo.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../models/Location.dart';

class ImageUtil{
  static const String CAMERA_BG = "assets/images/backgrounds/cameras_background.png";
  static const String DANDY_BG = "assets/images/backgrounds/home_background_4.png";
  static const String LOGIN_BG_BLUE_MOUNTAIN = 'assets/images/backgrounds/login_background_blue_mountain.png';
  static const String LOGIN_BG_PEACH_MOUNTAIN = 'assets/images/backgrounds/login_background_peach_mountain.png';
  static const String LOGIN_BG_PEACH_DARK_MOUNTAIN = 'assets/images/backgrounds/login_background_peach_dark_mountain.png';
  static const String LOGIN_BG_SUN = 'assets/images/backgrounds/login_background_sun.png';
  static const String LOGIN_BG_LOGO_FLOWER = 'assets/images/dandy_light_logo_icon.png';
  static const String JOB_DETAILS_BG = "assets/images/backgrounds/job_details_background.png";
  static const String INCOME_BG = "assets/images/backgrounds/income_background_lighter.png";
  static const String EXPENSES_BG = "assets/images/backgrounds/expenses_background_peach.png";

  // static List<String> profileIcons = [
  //
  // ]

  static List<String> femaleIcons = [
    "assets/images/people/girl1.png",
    "assets/images/people/girl2.png",
    "assets/images/people/girl3.png",
    "assets/images/people/girl4.png",
    "assets/images/people/girl5.png",
    "assets/images/people/girl7.png",
    "assets/images/people/girl6.png",
    "assets/images/people/girl8.png"
  ];
  static List<String> maleIcons = [
    "assets/images/people/boy1.png",
    "assets/images/people/boy2.png",
    "assets/images/people/boy3.png",
    "assets/images/people/boy4.png",
    "assets/images/people/boy5.png",
    "assets/images/people/boy7.png",
    "assets/images/people/boy6.png",
    "assets/images/people/boy8.png"
  ];

  static List<String> jobIcons = [
    'assets/images/job_types/commercial_advertising.png',
    'assets/images/job_types/anniversary.png',
    'assets/images/job_types/real_estate_architecture.png',
    'assets/images/job_types/birthday.png',
    'assets/images/job_types/boudoir.png',
    'assets/images/job_types/breastfeeding.png',
    'assets/images/job_types/engagement.png',
    'assets/images/job_types/event.png',
    'assets/images/job_types/family_portrait.png',
    'assets/images/people/girl3.png',
    'assets/images/job_types/maternity.png',
    'assets/images/job_types/modeling.png',
    'assets/images/job_types/nature.png',
    'assets/images/job_types/newborn.png',
    'assets/images/job_types/other.png',
    'assets/images/job_types/pet.png',
    'assets/images/job_types/wedding.png',
  ];

  static List<String> jobStageIcons = [
    'assets/images/job_progress/inquiry_received.png',
    'assets/images/job_progress/followup_sent.png',
    'assets/images/job_progress/proposal_sent.png',
    'assets/images/job_progress/proposal_signed.png',
    'assets/images/job_progress/deposit_received.png',
    'assets/images/job_progress/planning_complete.png',
    'assets/images/job_progress/session_complete.png',
    'assets/images/job_progress/payment_requested.png',
    'assets/images/job_progress/payment_received.png',
    'assets/images/job_progress/editing_complete.png',
    'assets/images/job_progress/gallery_sent.png',
    'assets/images/job_progress/feedback_requested.png',
    'assets/images/job_progress/feedback_received.png',
    'assets/images/job_progress/job_complete.png',
  ];

  static List<String> leadSourceIconsWhite = [
    'assets/images/icons/word_of_mouth_icon_white.png',
    'assets/images/icons/instagram_icon_white.png',
    'assets/images/icons/free_giveaway_icon_white.png',
    'assets/images/icons/website_icon_white.png',
    'assets/images/icons/business_card_icon_white.png',
    'assets/images/icons/facebook_icon_white.png',
    'assets/images/icons/wordpress_icon_white.png',
    'assets/images/icons/email_icon_white.png',
  ];

  static List<String> leadSourceIconsPeach = [
    'assets/images/icons/word_of_mouth_icon_peach.png',
    'assets/images/icons/instagram_icon_peach_light.png',
    'assets/images/icons/free_giveaway_icon_peach.png',
    'assets/images/icons/website_icon_peach.png',
    'assets/images/icons/business_card_icon_peach.png',
    'assets/images/icons/facebook_icon_peach.png',
    'assets/images/icons/wordpress_icon_peach.png',
    'assets/images/icons/email_icon_peach_light.png',
  ];

  static String getLeadSourceText(String fileLocation){
    String leadSourceTitle = Client.LEAD_SOURCE_OTHER;
    switch(fileLocation){
      case 'assets/images/icons/word_of_mouth_icon_white.png':
      case 'assets/images/icons/word_of_mouth_icon_peach.png':
        leadSourceTitle = Client.LEAD_SOURCE_WORD_OF_MOUTH;
        break;
      case 'assets/images/icons/instagram_icon_white.png':
      case 'assets/images/icons/instagram_icon_peach_light.png':
        leadSourceTitle = Client.LEAD_SOURCE_INSTAGRAM;
        break;
      case 'assets/images/icons/free_giveaway_icon_white.png':
      case 'assets/images/icons/free_giveaway_icon_peach.png':
        leadSourceTitle = Client.LEAD_SOURCE_GIVEAWAY;
        break;
      case 'assets/images/icons/website_icon_white.png':
      case 'assets/images/icons/website_icon_peach.png':
        leadSourceTitle = Client.LEAD_SOURCE_WEBSITE;
        break;
      case 'assets/images/icons/business_card_icon_white.png':
      case 'assets/images/icons/business_card_icon_peach.png':
        leadSourceTitle = Client.LEAD_SOURCE_BUSINESS_CARD;
        break;
      case 'assets/images/icons/facebook_icon_white.png':
      case 'assets/images/icons/facebook_icon_peach.png':
        leadSourceTitle = Client.LEAD_SOURCE_FACEBOOK;
        break;
      case 'assets/images/icons/wordpress_icon_white.png':
      case 'assets/images/icons/wordpress_icon_peach.png':
        leadSourceTitle = Client.LEAD_SOURCE_SOURCE_WORDPRESS;
        break;
      case 'assets/images/icons/email_icon_white.png':
      case 'assets/images/icons/email_icon_peach_light.png':
        leadSourceTitle = Client.LEAD_SOURCE_OTHER;
        break;
    }
    return leadSourceTitle;
  }

  static List<String> collectionIcons = [
    'assets/images/collection_icons/reminder_icon_white.png',
    'assets/images/collection_icons/poses_icon_white.png',
    'assets/images/icons/briefcase_icon_white.png',
    'assets/images/collection_icons/packages_icon_white.png',
    'assets/images/collection_icons/location_icon_white.png',
    'assets/images/collection_icons/auto_responses_icon_white.png',
    'assets/images/collection_icons/contract_icon_white.png',
    'assets/images/icons/calendar_icon_white.png',
    'assets/images/collection_icons/questionaire_icon_white.png',
    'assets/images/collection_icons/workflow_icon_white.png',
  ];

  static String locationPin = 'assets/images/collection_icons/location_pin_blue.png';
  static String reminderIcon = 'assets/images/collection_icons/reminder_icon_white.png';

  static String getRandomPriceProfileIcon() {
    var intValue = Random().nextInt(7);
    return pricingProfileIcons[intValue];
  }

  static List<String> pricingProfileIcons = [
    'assets/images/collection_icons/pricing_profile_icons/money_stacks_icon_gold.png',
    'assets/images/collection_icons/pricing_profile_icons/coins_icon_gold.png',
    'assets/images/collection_icons/pricing_profile_icons/dollar_sign_icon_gold.png',
    'assets/images/collection_icons/pricing_profile_icons/coin_icon_gold.png',
    'assets/images/collection_icons/pricing_profile_icons/coin_stacks_icon_gold.png',
    'assets/images/collection_icons/pricing_profile_icons/piggy_bank_icon_gold.png',
    'assets/images/collection_icons/pricing_profile_icons/wallet_icon_gold.png',
    'assets/images/collection_icons/pricing_profile_icons/money_bag_icon_gold.png',
  ];

  static List<String> pricingProfileIconsWhite = [
    'assets/images/collection_icons/pricing_profile_icons/money_stacks_icon_white.png',
    'assets/images/collection_icons/pricing_profile_icons/coins_icon_white.png',
    'assets/images/collection_icons/pricing_profile_icons/dollar_sign_icon_white.png',
    'assets/images/collection_icons/pricing_profile_icons/coin_icon_white.png',
    'assets/images/collection_icons/pricing_profile_icons/coin_stacks_icon_white.png',
    'assets/images/collection_icons/pricing_profile_icons/piggy_bank_icon_white.png',
    'assets/images/collection_icons/pricing_profile_icons/wallet_icon_white.png',
    'assets/images/collection_icons/pricing_profile_icons/money_bag_icon_white.png',
  ];

  static AssetImage getJobStageCompleteIconBlack() {
    return AssetImage('assets/images/job_progress/complete_check.png');
  }

  static AssetImage getJobStageCompleteIconWhite() {
    return AssetImage('assets/images/job_progress/white_check.png');
  }

  static AssetImage getUndoImageAsset() {
    return AssetImage('assets/images/job_progress/undo.png');
  }

  static String getJobStageText(String icon) {
    switch(icon) {
      case 'assets/images/job_progress/inquiry_received.png':
        return 'Inquiry received';
      case 'assets/images/job_progress/followup_sent.png':
        return 'Followup sent';
      case 'assets/images/job_progress/proposal_sent.png':
        return 'Contract sent';
      case 'assets/images/job_progress/proposal_signed.png':
        return 'Contract signed';
      case 'assets/images/job_progress/planning_complete.png':
        return 'Planning complete';
      case 'assets/images/job_progress/session_complete.png':
        return 'Session complete';
      case 'assets/images/job_progress/editing_complete.png':
        return 'Editing complete';
      case 'assets/images/job_progress/gallery_sent.png':
        return 'Gallery sent';
      case 'assets/images/job_progress/payment_requested.png':
        return 'Payment requested';
      case 'assets/images/job_progress/feedback_requested.png':
        return 'Feedback requested';
      case 'assets/images/job_progress/feedback_received.png':
        return 'Feedback Received';
      case 'assets/images/job_progress/payment_received.png':
        return 'Payment received';
      case 'assets/images/job_progress/deposit_received.png':
        return 'Deposit received';
      case 'assets/images/job_progress/job_complete.png':
        return 'Job Complete';
    }
    return'';
  }

  static String getJobTypeText(String icon) {
    switch(icon){
      case 'assets/images/job_types/anniversary.png':
        return 'Anniversary';
        break;
      case 'assets/images/job_types/birthday.png':
        return 'Birthday';
        break;
      case 'assets/images/job_types/Boudoir.png':
        return 'Boudoir';
        break;
      case 'assets/images/job_types/breastfeeding.png':
        return 'Breastfeeding';
        break;
      case 'assets/images/job_types/commercial_advertising.png':
        return 'Advertising';
        break;
      case 'assets/images/job_types/engagement.png':
        return 'Engagement';
        break;
      case 'assets/images/job_types/family_portrait.png':
        return 'Family';
        break;
      case 'assets/images/job_types/maternity.png':
        return 'Maternity';
        break;
      case 'assets/images/job_types/modeling.png':
        return 'Modeling';
        break;
      case 'assets/images/job_types/nature.png':
        return 'Nature';
        break;
      case 'assets/images/job_types/newborn.png':
        return 'Newborn';
        break;
      case 'assets/images/job_types/other.png':
        return 'Other';
        break;
      case 'assets/images/job_types/pet.png':
        return 'Pet';
        break;
      case 'assets/images/job_types/real_estate_architecture.png':
        return 'Architecture';
        break;
      case 'assets/images/job_types/wedding.png':
        return 'Wedding';
        break;
      case 'assets/images/job_types/event.png':
        return 'Event';
        break;
      case 'assets/images/people/girl3.png':
        return 'Headshots';
        break;
    }
    return '';
  }

  static String getCollectionIconName(String fileLocation){
    String iconName = '';
    switch(fileLocation){
      case 'assets/images/icons/briefcase_icon_white.png':
        iconName = 'Job Types';
        break;
      case 'assets/images/collection_icons/poses_icon_white.png':
        iconName = 'Poses';
        break;
      case 'assets/images/collection_icons/location_icon_white.png':
        iconName = 'Locations';
        break;
      case 'assets/images/collection_icons/reminder_icon_white.png':
        iconName = 'Reminders';
        break;
      case 'assets/images/collection_icons/packages_icon_white.png':
        iconName = 'Price Packages';
        break;
      case 'assets/images/collection_icons/contract_icon_white.png':
        iconName = 'Contracts';
        break;
      case 'assets/images/collection_icons/checklist_icon_white.png':
        iconName = 'Checklists';
        break;
      case 'assets/images/collection_icons/questionaire_icon_white.png':
        iconName = 'Questionnaires';
        break;
      case 'assets/images/collection_icons/workflow_icon_white.png':
        iconName = 'Client Guides';
        break;
      case 'assets/images/collection_icons/auto_responses_icon_white.png':
        iconName = 'Responses';
        break;
      case 'assets/images/collection_icons/automation_icon_white.png':
        iconName = 'Automation';
        break;
      case 'assets/images/icons/calendar_icon_white.png':
        iconName = 'Automated Booking';
        break;
    }
    return iconName;
  }

  static AssetImage getRandomJobIcon(){
    return AssetImage(jobIcons[Random().nextInt(15)]);
  }

  static AssetImage getRandomPersonIcon() {
    return AssetImage(femaleIcons[Random().nextInt(8)]);
  }

  static AssetImage getDefaultPricingProfileIcon() {
    return AssetImage(pricingProfileIcons[0]);
  }

  static AssetImage getDeviceEventAssetImage() {
    return AssetImage('assets/images/job_progress/device_event.png');
  }

  static AssetImage getSunsetAssetImage() {
    return AssetImage('assets/images/sunset.png');
  }

  static AssetImage getTrashIconWhite() {
    return AssetImage('assets/images/icons/trash_icon_white.png');
  }

  static AssetImage getTrashIconPeach() {
    return AssetImage('assets/images/icons/trash_icon_peach.png');
  }

  static AssetImage getJobStageImageFromStage(JobStage stage) {
    String imageLocation = '';
    switch(stage.stage){
      case JobStage.STAGE_1_INQUIRY_RECEIVED:
        imageLocation = jobStageIcons[0];
        break;
      case JobStage.STAGE_2_FOLLOWUP_SENT:
        imageLocation = jobStageIcons[1];
        break;
      case JobStage.STAGE_3_PROPOSAL_SENT:
        imageLocation = jobStageIcons[2];
        break;
      case JobStage.STAGE_4_PROPOSAL_SIGNED:
        imageLocation = jobStageIcons[3];
        break;
      case JobStage.STAGE_5_DEPOSIT_RECEIVED:
        imageLocation = jobStageIcons[4];
        break;
      case JobStage.STAGE_6_PLANNING_COMPLETE:
        imageLocation = jobStageIcons[5];
        break;
      case JobStage.STAGE_7_SESSION_COMPLETE:
        imageLocation = jobStageIcons[6];
        break;
      case JobStage.STAGE_8_PAYMENT_REQUESTED:
        imageLocation = jobStageIcons[7];
        break;
      case JobStage.STAGE_9_PAYMENT_RECEIVED:
        imageLocation = jobStageIcons[8];
        break;
      case JobStage.STAGE_10_EDITING_COMPLETE:
        imageLocation = jobStageIcons[9];
        break;
      case JobStage.STAGE_11_GALLERY_SENT:
        imageLocation = jobStageIcons[10];
        break;
      case JobStage.STAGE_12_FEEDBACK_REQUESTED:
        imageLocation = jobStageIcons[11];
        break;
      case JobStage.STAGE_13_FEEDBACK_RECEIVED:
        imageLocation = jobStageIcons[12];
        break;
      case JobStage.STAGE_14_JOB_COMPLETE:
        imageLocation = jobStageIcons[13];
        break;
    }
    return AssetImage(imageLocation);
  }

  static const String DANDYLIGHT_LOGO_ICON = "dandy_light_logo_icon.png";
  static const String DANDYLIGHT_SAMPLE_BRAND = "dandy_light_sample_brand.png";

  static String path(String assetId) {
    return PlatformInfo().isWeb() ? 'assets/images/$assetId' : assetId;
  }
}