import 'dart:math';
import 'package:client_safe/models/Client.dart';
import 'package:flutter/widgets.dart';

class ImageUtil{
  static const String CAMERA_BG = "assets/images/backgrounds/cameras_background.jpg";

  static List<String> femaleIcons = [
    "assets/images/people/female1.png",
    "assets/images/people/female2.png",
    "assets/images/people/female3.png",
    "assets/images/people/female4.png",
    "assets/images/people/female5.png",
    "assets/images/people/female6.png",
    "assets/images/people/female7.png"
  ];
  static List<String> maleIcons = [
    "assets/images/people/male1.png",
    "assets/images/people/male2.png",
    "assets/images/people/male3.png",
    "assets/images/people/male4.png",
    "assets/images/people/male5.png",
    "assets/images/people/male6.png",
    "assets/images/people/male7.png",
    "assets/images/people/male8.png"
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
    'assets/images/job_types/event.png'];

  static List<String> leadSourceIcons = [
    'assets/images/lead_source_type/lead_source_word_of_mouth.png',
    'assets/images/lead_source_type/lead_source_instagram.png',
    'assets/images/lead_source_type/lead_source_giveaway.png',
    'assets/images/lead_source_type/lead_source_website.png',
    'assets/images/lead_source_type/lead_source_blog.png',
    'assets/images/lead_source_type/lead_source_business_card.png',
    'assets/images/lead_source_type/lead_source_facebook.png',
    'assets/images/lead_source_type/lead_source_instagram_influencer.png',
  ];

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
      case 'assets/images/lead_source_type/lead_source_blog.png':
        leadSourceTitle = Client.LEAD_SOURCE_BLOG;
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
    }
    return leadSourceTitle;
  }

  static AssetImage getRandomJobIcon(){
    return AssetImage(jobIcons[Random().nextInt(15)]);
  }

  static AssetImage getRandomPersonIcon(bool isFemale) {
    if(isFemale){
      return AssetImage(femaleIcons[Random().nextInt(7)]);
    }else{
      return AssetImage(maleIcons[Random().nextInt(8)]);
    }
  }
}