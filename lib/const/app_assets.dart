import 'package:flutter/material.dart';

class AppAssets {
  // Base Path
  static const String _basePath = 'assets/images/';
  static const String _galleryPath = '${_basePath}photo_gallery/';

  // Frame & Landing Images
  static const String landingInvitationCard = '${_basePath}Frame_9.png';
  static const String leftLandingFlower =
      '${_basePath}left_landing_element.png';
  static const String rightLandingFlower =
      '${_basePath}right_landing_element.png';
  static const String flower = '${_basePath}Flower.webp';
  static const String background = '${_basePath}bg_2_resized.webp';
  static const String envelopeBack = '${_basePath}letter_cover_back.webp';
  static const String envelopeFront = '${_basePath}letter_cover_front.webp';
  static const String poster = '${_basePath}Poster.webp';
  static const String envelope = '${_basePath}letter.png';

  // Gallery Images
  static const List<String> galleryImages = [
    '${_galleryPath}1.webp',
    '${_galleryPath}2.webp',
    '${_galleryPath}3.webp',
    '${_galleryPath}4.webp',
    '${_galleryPath}5.webp',
    '${_galleryPath}6.webp',
    '${_galleryPath}7.webp',
    '${_galleryPath}8.webp',
    '${_galleryPath}9.jpeg',
    '${_galleryPath}10.jpg',
    '${_galleryPath}11.jpeg',
    '${_galleryPath}12.jpg',
    '${_galleryPath}13.jpg',
    '${_galleryPath}14.jpg',
    '${_galleryPath}15.jpg',
    '${_galleryPath}16.jpg',
    '${_galleryPath}17.jpg',
    '${_galleryPath}18.jpg',
    '${_galleryPath}19.jpg',
    '${_galleryPath}20.jpg',
    '${_galleryPath}21.jpg',
    '${_galleryPath}22.jpg',
    '${_galleryPath}23.jpg',
    '${_galleryPath}24.jpg',
  ];

  // 🚀 Single function to pre-cache all heavy images at once!
  static void precacheAllAssets(BuildContext context) {
    // 1. Single Assets
    final singleAssets = [
      landingInvitationCard,
      leftLandingFlower,
      rightLandingFlower,
      flower,
      background,
      envelopeBack,
      envelopeFront,
      poster,
    ];

    for (final path in singleAssets) {
      precacheImage(AssetImage(path), context);
    }

    // 2. Gallery Images Loop
    for (final path in galleryImages) {
      precacheImage(AssetImage(path), context);
    }
  }
}
