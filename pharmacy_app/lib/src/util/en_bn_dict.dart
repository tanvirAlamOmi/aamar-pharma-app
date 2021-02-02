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

    // HomePage
    'HOME': 'হোম',
    'ORDER MEDICINES AND MORE': 'ওষুধ এবং অন্যান্য অর্ডার করুন',
    'All medicines except OTC medicines require prescription*':
        'ওটিসি ওষুধ ছাড়া বাকিগুলোর ক্ষেত্রে অবশই প্রেসক্রিপশন আবশ্যক*',

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
