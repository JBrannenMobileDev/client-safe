import 'dart:math';

import 'package:client_safe/models/Job.dart';
import 'package:flutter/widgets.dart';

class ImageUtil{
  static AssetImage getMalePersonIcon(){
    List<String> maleIcons = [
      'assets/images/male_black_hair.png',
      'assets/images/male_black_hair_2.png',
      'assets/images/male_brown_hair_collar.png',
      'assets/images/male_brown_hair_goat.png',
      'assets/images/male_messy_black_hair.png',
      'assets/images/male_white_hair.png',
      'assets/images/male_white_hair_tanktop.png',
      'assets/images/middle_age_male_brown_hair.png',
      'assets/images/young_male.png'
    ];
    return AssetImage(maleIcons[Random().nextInt(9)]);
  }

  static AssetImage getFemalePersonIcon(){
    List<String> maleIcons = [
      'assets/images/female_blonde.png',
      'assets/images/female_blue_afro.png',
      'assets/images/female_brown_ponytail.png',
      'assets/images/female_bun_brown_hair.png',
      'assets/images/female_flat_brown_hair.png',
      'assets/images/young_female_black_hair.png'
    ];
    return AssetImage(maleIcons[Random().nextInt(6)]);
  }

  static AssetImage getGenderNeutralPersonIcon(){
    return AssetImage('assets/images/gender_nuetral_white_hair.png');
  }

  static AssetImage getRandomJobIcon(){
    List<String> jobIcons = [
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
    return AssetImage(jobIcons[Random().nextInt(15)]);
  }

  static AssetImage getJobIcon(String jobType){
    return AssetImage(jobType);
  }

  static AssetImage getCamerasBg(){
    return AssetImage('assets/images/backgrounds/cameras_background.jpg');
  }
}