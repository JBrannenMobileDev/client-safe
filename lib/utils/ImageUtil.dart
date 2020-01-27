import 'dart:math';
import 'package:client_safe/models/Client.dart';
import 'package:flutter/widgets.dart';

class ImageUtil{
  static const String CAMERA_BG = "assets/images/backgrounds/cameras_background.png";
  static const String DANDY_BG = "assets/images/backgrounds/dandy_light_background.png";

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
    'assets/images/job_types/anniversary.png',
    'assets/images/job_types/birthday.png',
    'assets/images/job_types/breastfeeding.png',
    'assets/images/job_types/commercial_advertising.png',
    'assets/images/job_types/engagement.png',
    'assets/images/job_types/family_portrait.png',
    'assets/images/job_types/maternity.png',
    'assets/images/job_types/modeling.png',
    'assets/images/job_types/nature.png',
    'assets/images/job_types/newborn.png',
    'assets/images/job_types/other.png',
    'assets/images/job_types/pet.png',
    'assets/images/job_types/real_estate_architecture.png',
    'assets/images/job_types/wedding.png',
    'assets/images/job_types/event.png',
    'assets/images/people/girl3.png',
  ];

  static List<String> jobStageIcons = [
    'assets/images/job_progress/inquiry_received.png',
    'assets/images/job_progress/followup_sent.png',
    'assets/images/job_progress/proposal_sent.png',
    'assets/images/job_progress/proposal_signed.png',
    'assets/images/job_progress/planning_complete.png',
    'assets/images/job_progress/session_complete.png',
    'assets/images/job_progress/editing_complete.png',
    'assets/images/job_progress/gallery_sent.png',
    'assets/images/job_progress/payment_requested.png',
    'assets/images/job_progress/feedback_requested.png',
    'assets/images/job_progress/feedback_received.png',
    'assets/images/collection_icons/pricing_profile_icons/pricing_profile_money_bag.png',
  ];

  static List<String> leadSourceIcons = [
    'assets/images/lead_source_type/lead_source_word_of_mouth.png',
    'assets/images/lead_source_type/lead_source_instagram.png',
    'assets/images/lead_source_type/lead_source_giveaway.png',
    'assets/images/lead_source_type/lead_source_website.png',
    'assets/images/lead_source_type/lead_source_business_card.png',
    'assets/images/lead_source_type/lead_source_facebook.png',
    'assets/images/lead_source_type/lead_source_instagram_influencer.png',
    'assets/images/lead_source_type/lead_source_other.png',
  ];

  static List<String> collectionIcons = [
    'assets/images/collection_icons/collection_pricing_profiles.png',
    'assets/images/collection_icons/collection_photoshoot_locations.png',
    'assets/images/collection_icons/collection_example_poses.png',
    'assets/images/collection_icons/collection_contracts.png',
    'assets/images/collection_icons/collection_work_flows.png',
  ];

  static String locationPin = 'assets/images/collection_icons/location_pin.png';

  static List<String> pricingProfileIcons = [
    'assets/images/collection_icons/pricing_profile_icons/pricing_profile_bills.png',
    'assets/images/collection_icons/pricing_profile_icons/pricing_profile_coins.png',
    'assets/images/collection_icons/pricing_profile_icons/pricing_profile_dollar.png',
    'assets/images/collection_icons/pricing_profile_icons/pricing_profile_free.png',
    'assets/images/collection_icons/pricing_profile_icons/pricing_profile_money_bag.png',
    'assets/images/collection_icons/pricing_profile_icons/pricing_profile_price_tag.png',
    'assets/images/collection_icons/pricing_profile_icons/pricing_profile_sale.png',
    'assets/images/collection_icons/pricing_profile_icons/pricing_profile_sale_tag.png',
  ];

  static AssetImage getJobStageCompleteIcon() {
    return AssetImage('assets/images/job_progress/check_mark.png');
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
        return 'Feedback received';
      case 'assets/images/collection_icons/pricing_profile_icons/pricing_profile_money_bag.png':
        return 'Payment received';
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
    String iconName = "";
    switch(fileLocation){
      case 'assets/images/collection_icons/collection_pricing_profiles.png':
        iconName = "Packages";
        break;
      case 'assets/images/collection_icons/collection_photoshoot_locations.png':
        iconName = "Locations";
        break;
      case 'assets/images/collection_icons/collection_contracts.png':
        iconName = "Contracts";
        break;
      case 'assets/images/collection_icons/collection_example_poses.png':
        iconName = "Poses";
        break;
      case 'assets/images/collection_icons/collection_work_flows.png':
        iconName = 'Workflows';
    }
    return iconName;
  }

  static String getLeadSourceText(String fileLocation){
    String leadSourceTitle = "";
    switch(fileLocation){
      case 'assets/images/lead_source_type/lead_source_word_of_mouth.png':
        leadSourceTitle = Client.LEAD_SOURCE_WORD_OF_MOUTH;
        break;
      case 'assets/images/lead_source_type/lead_source_instagram.png':
        leadSourceTitle = Client.LEAD_SOURCE_INSTAGRAM;
        break;
      case 'assets/images/lead_source_type/lead_source_giveaway.png':
        leadSourceTitle = Client.LEAD_SOURCE_GIVEAWAY;
        break;
      case 'assets/images/lead_source_type/lead_source_website.png':
        leadSourceTitle = Client.LEAD_SOURCE_WEBSITE;
        break;
      case 'assets/images/lead_source_type/lead_source_business_card.png':
        leadSourceTitle = Client.LEAD_SOURCE_BUSINESS_CARD;
        break;
      case 'assets/images/lead_source_type/lead_source_facebook.png':
        leadSourceTitle = Client.LEAD_SOURCE_FACEBOOK;
        break;
      case 'assets/images/lead_source_type/lead_source_instagram_influencer.png':
        leadSourceTitle = Client.LEAD_SOURCE_SOCIAL_MEDIA_INFLUENCER;
        break;
      case 'assets/images/lead_source_type/lead_source_other.png':
        leadSourceTitle = Client.LEAD_SOURCE_OTHER;
        break;
    }
    return leadSourceTitle;
  }

  static AssetImage getRandomJobIcon(){
    return AssetImage(jobIcons[Random().nextInt(15)]);
  }

  static AssetImage getRandomPersonIcon(bool isFemale) {
    if(isFemale){
      return AssetImage(femaleIcons[Random().nextInt(8)]);
    }else{
      return AssetImage(maleIcons[Random().nextInt(8)]);
    }
  }

  static AssetImage getDefaultPricingProfileIcon() {
    return AssetImage(pricingProfileIcons[0]);
  }
}