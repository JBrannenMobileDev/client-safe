import 'dart:math';
import 'package:flutter/widgets.dart';

class ImageUtil{
  static const String CAMERA_BG = "assets/images/backgrounds/cameras_background.jpg";

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
}