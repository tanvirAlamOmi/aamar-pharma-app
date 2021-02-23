import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:intl/intl.dart';

class EnBnDict {
  static String en_bn_convert({String text}) {
    String textMessage = text;
    if (Store.instance.appState.language == ClientEnum.LANGUAGE_ENGLISH) {
      return textMessage;
    }

    if (EnBnDict.DICTINARY.containsKey(textMessage)) {
      return EnBnDict.DICTINARY[text];
    }
    return textMessage;
  }

  static String en_bn_number_convert({int number}) {
    if (Store.instance.appState.language == ClientEnum.LANGUAGE_ENGLISH) {
      return number.toString();
    }

    String numberInBn = '';
    for (int i = 0; i < number.toString().length; i++) {
      numberInBn += EnBnDict.DICTINARY[number.toString()[i]];
    }
    return numberInBn;
  }

  static String time_bn_convert_with_time_type({String text}) {
    DateTime date = DateFormat.jm().parse(text);
    String timeType = '';

    if (date.hour >= 0 && date.hour < 6) {
      timeType = 'রাত';
    } else if (date.hour >= 6 && date.hour < 12) {
      timeType = 'সকাল';
    } else if (date.hour >= 12 && date.hour < 17) {
      timeType = 'দুপুর';
    } else if (date.hour >= 17 && date.hour < 19) {
      timeType = 'সন্ধ্যা';
    } else if (date.hour >= 19 && date.hour <= 23) {
      timeType = 'রাত';
    }

    text = text.replaceAll('AM', '');
    text = text.replaceAll('PM', '');
    text = text.replaceAll(' ', '');

    String numberBangla = '';
    for (int i = 0; i < text.length; i++) {
      if (EnBnDict.DICTINARY.containsKey(text[i])) {
        numberBangla += EnBnDict.DICTINARY[text[i]];
      } else {
        numberBangla += text[i];
      }
    }
    numberBangla += ' ' + timeType;
    return numberBangla;
  }

  static String en_bn_font() {
    if (Store.instance.appState.language == ClientEnum.LANGUAGE_ENGLISH) {
      return null;
    }
    return 'solaiman';
  }

  static final DICTINARY = {
    //Drawer
    'REPEAT ORDERS': 'অর্ডার রিপিট করুন',
    'SPECIAL REQUEST': 'বিশেষ অনুরোধ',
    'CONSULT PHARMACIST': 'বিশেষজ্ঞ পরামর্শ',
    'HELP & FAQ': 'সাহায্য এবং প্রশ্ন',
    'ABOUT': 'জানুন আমাদের সম্পর্কে',
    'LANGUAGE (BANGLA)': 'ভাষা(বাংলা)',
    'LOG OUT': 'লগ আউট',

    // Bottom Navigation Bar
    'Home': 'হোম',
    'Orders': 'অর্ডারসমূহ',
    'Account': 'একাউন্ট',

    // HomePage
    'HOME': 'হোম',
    'ORDER MEDICINES AND MORE': 'ওষুধ এবং অন্যান্য অর্ডার করুন',
    'We offer medicines, wellness products, COVID essentials, Devices and more':
        'আমাদের রয়েছে ঔষধ, স্বাস্থ্যদ্রব্য, জরুরি কোভিড দ্রব্য, ডিভাইস ইত্যাদি..',
    'ORDER MEDICINES AND MORE': 'ওষুধ এবং অন্যান্য অর্ডার করুন',
    'All medicines except OTC medicines require prescription*':
        'ওটিসি ওষুধ ছাড়া বাকিগুলোর ক্ষেত্রে প্রেসক্রিপশন আবশ্যক*',
    'UPLOAD PRESCRIPTION / PHOTO': 'প্রেসক্রিপশন/ছবি আপলোড করুন',
    'ADD ITEMS MANUALLY': 'ম্যানুয়্যালি আইটেম যুক্ত করুন',
    'ORDER DELIVERY TIME': 'অর্ডার ডেলিভারির সময়',
    '10 AM TO 10 PM': 'সকাল ১০ টা থেকে রাত ১০ টা ',
    'CALL US': 'কল করুন',

    //Add Items Page
    'ADD ITEMS': 'আইটেম যুক্ত করুন ',
    'Item Name': 'আইটেমের নাম',
    'Napa, Histasin': 'নাপা, হিস্টাসিন ',
    'Unit': 'একক',
    'e.g. mg,ml': 'উদাঃ মি,গ্রা, এমএল ',
    'Quantity': 'পরিমাণ',
    'e.g. 10,15': 'উদাঃ ১০,১৫ ',
    'ADD ITEM': 'আইটেম যোগ করুন ',
    'ADDED ITEMS': 'আপনার আইটেমসমূহ',
    'QUANTITY: ': 'পরিমাণ: ',

    // Confirm Order Page
    'CONFIRM ORDER': 'অর্ডার নিশ্চিত করুন',
    'DELIVERY TIME (EVERYDAY 10 AM TO 10 PM)':
        'ডেলিভারির সময়(প্রতিদিন সকাল ১০টা থেকে রাত ১০টা)',
    'Day': 'দিন',
    'Time': 'সময়',
    'Today': 'আজ',
    'Tomorrow': 'আগামীকাল',
    'Repeat Order': 'রিপিট অর্ডার',
    'Select this option if you want to get this order on a regular basis':
        'এই অর্ডারটি নিয়মিত ডেলিভারি পেতে হলে এই অপশনটি নির্বাচন করুন',
    'Every': 'প্রতি',
    'Week': '১ সপ্তাহ পর',
    '15 Days': '১৫ দিন পর',
    '1 Month': '১ মাস পর',
    'Saturday': 'শনিবার',
    'Sunday': 'রবিবার',
    'Monday': 'সোমবার',
    'Tuesday': 'মঙ্গলবার',
    'Wednesday': 'বুধবার',
    'Thursday': 'বৃহস্পতিবার',
    'Friday': 'শুক্রবার',
    'Add New Address': 'নতুন ঠিকানা যুক্ত করুন',
    'PERSONAL DETAILS': 'ব্যক্তিগত তত্থ্য',
    'NAME': 'নাম',
    'EMAIL': 'ইমেইল',
    'Phone Number': 'ফোন নাম্বার',
    'Mr. XYZ': 'উদাঃ জনাব সৈকত',
    'Your Phone Number': 'আপনার মোবাইল নাম্বার',

    // General
    'REMOVE': 'রিমোভ করুন',
    'SUBMIT': 'সম্পন্ন করুন',

    //
    'AM': 'দিন',
    'PM': 'রাত',

    // Numbers
    ':': ':',
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };
}

//
// static String time_bn_convert({String text}) {
// if (text.contains('PM')) {
// String textHourPortion = text.split(':')[0];
// String textMinutePortion = text.split(':')[1];
//
// textHourPortion = (int.parse(textHourPortion) + 12).toString();
//
// text = textHourPortion + ':' + textMinutePortion;
// }
//
// text = text.replaceAll('AM', '');
// text = text.replaceAll('PM', '');
// text = text.replaceAll(' ', '');
//
// String numberBangla = '';
// for (int i = 0; i < text.length; i++) {
// if (EnBnDict.DICTINARY.containsKey(text[i])) {
// numberBangla += EnBnDict.DICTINARY[text[i]];
// } else {
// numberBangla += text[i];
// }
// }
// return numberBangla;
// }
