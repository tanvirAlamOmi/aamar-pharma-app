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

  static String en_bn_number_convert({dynamic number}) {
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
    'REFER A FRIEND': 'পরিচিতজনকে রেফার করুন',
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

    // Upload Prescription Verify Page
    'UPLOAD PRESCRIPTION': 'প্রেসক্রিপশন আপলোড',
    ' UPLOADED PHOTO(s)': 'টি আপলোডকৃত ছবি',
    'Add Notes': 'নোট/নির্দেশনা যুক্ত করুন',
    'Notes e.g. I need all the medicines': 'উদাঃ আমার সবগুলো ওষুধ প্রয়োজনীয়',
    '1 image is mandatory for the prescription':
        'প্রেসক্রিপশনের জন্য অন্তত একটি ছবি আবশ্যক',

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
    'Please add a delivery address': 'অনুগ্রহপূর্বক ডেলিভারি ঠিকানা যুক্ত করুন',
    'Please provide a name': 'দয়া করে নামের ঘরটি পূর্ণ করুন',
    'Please provide a valid email address': 'যথাযথ ইমেইল এড্রেস আবশ্যক',
    'Please provide a valid 11 digit Bangladeshi Number':
        '১১ ডিজিটের যথাযথ মোবাইল নাম্বার আবশ্যক',
    'CONFIRM SUBMITTING ORDER?': 'অর্ডারটি নিশ্চিত করতে আপনার সম্মতি আছে?',
    'Order is submitted.': 'অর্ডারটি গৃহীত হয়েছে।',
    'Submitting Order...': 'অর্ডারটি নেয়া হচ্ছে',


    // Order Page
    'ORDERS': 'অর্ডারসমূহ',

    // Add New Address Page
    'ADD ADDRESS': 'ঠিকানা যুক্ত করুন',
    'Address Type': 'ঠিকানার ধরণ',
    'Home/Office': 'বাসা/অফিস',
    'Address': 'ঠিকানা',
    '39/A Housing Estate...': '৩৯/এ হাউজিং এস্টেট',
    'Select Area': 'এলাকা নির্বাচন করুন',
    'Area': 'এলাকা',
    'Please fill all the data': 'অনুগ্রহপূর্বক শবগুলো ঘর পূর্ণ করুন',
    'Please wait': 'অনুগ্রহপূর্বক অপেক্ষা করুন।',
    'Delivery Address Added Successfully':
        'নতুন ডেলিভারি এড্রেস যুক্ত করা হয়েছে।',

    // Login Page
    'LOGIN': 'লগিন',
    'Enter your mobile number': 'আপনার মোবাইল নাম্বারটি দিন',
    'We will send you a verification code by text message(SMS)':
        'আমরা আপ্নকে এস,এম,এস এর মাধ্যমে একটি ভেরিফিকেসন কোড পাঠাবো',

    // Verification Page
    'PHONE VERIFICATION': 'ফোন ভেরিফিকেইসন',
    'SUBMIT CODE': 'কোড যাচাই করুন',
    'Resend Code': 'আবার কোড পাঠান',
    'CONTINUE': 'পরবর্তী ধাপ',
    'Please enter the code.': 'অনুগ্রহপূর্বক কোডটি দিন।',
    'Resending code in 10 seconds': '১০ সেকেন্ডের মধ্যে আবার কোড পাঠানো হচ্ছে।',
    'Code Resent': 'কোড পাঠানো হয়েছে।',

    // My Details Page
    'MY DETAILS': 'আমার বৃত্তান্ত',
    'SAVE': 'সেইভ করুন',

    // Order Details Page
    'ORDER DETAILS': 'অর্ডার বৃত্তান্ত',
    'Email': 'ইমেইল',
    'DELIVERY ADDRESS': 'ডেলিভারি ঠিকানা',
    'CANCEL ORDER': 'অর্ডার ক্যান্সেল করুন',
    'Are you sure to cancel this order?':
        'আপনি কি এই অর্ডারটি ক্যান্সেল করতে চাচ্ছেন?',

    // Confirm Invoice Page
    'We only accept cash on delivery.':
        'আমরা ডেলিভারিতে কেবল নগদ টাকা গ্রহণ করে থাকি।',
    'Please keep cash ready upon delivery.':
        'অনুগ্রহপূর্বক ডেলিভারির সময় নগদ টাকা প্রস্তুত রাখুন।',
    'Before confirming order, please check invoice, edit quantity or remove items.':
        'অর্ডার নিশ্চিত করার আগে অনুগ্রহপূর্বক চালান বর্ণনা চেক করুন এবং প্রয়োজন হলে পরিমাণ বা আইটেম পরিবর্তন করুন',
    'View Order Details': 'অর্ডারের বৃত্তান্ত দেখুন',
    'Item': 'আইটেম',
    'Unit Cost': 'ইউনিট মূল্য',
    'Amount': 'টাকার অঙ্ক',
    'Subtotal': 'সাবটোটাল',
    'Delivery Fee': 'ডেলিভারি ফী',
    'Total': 'মোট টাকা',
    'Are you sure to confirm this invoice for this order?':
        'আপনি কি এই অর্ডারটির জন্য এই চালান এবং দামের বিষয়টি নিশ্চিত করেছেন?',
    'CANCEL REPEAT ORDER': 'অর্ডারের পুনরাবৃত্তি বন্ধ করুন',
    'Are you sure to stop this repeat order?':
    'এই অর্ডারের পুনরাবৃত্তি বন্ধ করে দিতে চাচ্ছেন?',
    'Repeat Order is cancelled': 'অর্ডারের পুনরাবৃত্তি বন্ধ হয়েছে।',
    'Order is cancelled' : 'অর্ডারটি ক্যান্সেল করা হয়েছে।',

    // Order Final Invoice Page
    'ORDER INVOICE DETAILS': 'অর্ডার চালান',
    'REORDER': 'পুনরায় এই অর্ডার করুন',
    'Invoice Number': 'চালান ক্রমিক নং',
    'Date Of Issue': 'চালানের তারিখ',
    'Billed to': 'বিল',

    // Order Card
    'Order ID: ': 'অর্ডার ক্রমিক নং: ',
    'Delivery:': 'ডেলিভারি:',

    // Drop Down Filter Card
    'SORT BY ORDER STATUS / ALL': 'অর্ডারের অবস্থা অনুযায়ী দেখুন / সকল অর্ডার',
    'Pending': 'প্রক্রিয়াধীন অর্ডারসমূহ',
    'Invoice sent': 'চালান দেয়া হয়েছে এমন অর্ডারসমূহ',
    'Confirmed': 'নিশ্চিত করা হয়েছে এমন অর্ডারসমূহ',
    'Delivered': 'ডেলিভারি সম্পন্ন হয়েছে এমন অর্ডারসমূহ',
    'Canceled': 'ক্যান্সেল করা হয়েছে এমন অর্ডারসমূহ',
    'PENDING': 'প্রক্রিয়াধীন',
    'INVOICE SENT': 'চালান দেয়া হয়েছে',
    'CONFIRMED': 'নিশ্চিত করা হয়েছে',
    'DELIVERED': 'ডেলিভারি সম্পন্ন হয়েছে',
    'CANCELED': 'ক্যান্সেল করা হয়েছে',

    // Repeat Order Card
    'NEXT DELIVERY ON': 'পরবর্তী ডেলিভারি',

    // Special Request Product Page
    'REQUEST A PRODUCT': 'পণ্যের আবেদন জানান',
    'REQUEST PRODUCT': 'পণ্যের আবেদন',
    'ADD PHOTO': 'ছবি যুক্ত করুন',
    'REQUEST RECEIVED': 'আবেদন গ্রহন',
    'Your request has been received.': 'আপনার আবেদনটি গৃহীত হয়েছে।',
    'We will notify you when we have your requested product.':
        'আপনার প্রয়োজনীয় পণ্যটির ব্যবস্থাপূর্বক আপনাকে জানানো হবে।',

    // Consult Pharmacist Page
    'REQUEST CALL BACK': 'কল ব্যাকের আবেদন',
    'For any kind of queries, feel free to consult with a pharmacist.':
        'আপনার যেকোনো জিজ্ঞাসা বা পরামর্শের জন্য বিশেষজ্ঞের কাছে কল ব্যাকের আবেদন জানান।',
    'Name': 'নাম',
    'You will get a call back within 30 minutes.':
        '৩০ মিনিটের মধ্যে আপনি কল ব্যাক পাবেন।',

    // General
    'REMOVE': 'রিমোভ করুন',
    'SUBMIT': 'সম্পন্ন করুন',
    'PROCEED': 'পরবর্তী ধাপ',
    'Empty List': 'কোন তথ্য/তালিকা নেই',
    'ARE YOU SURE..': 'আপনি কি নিশ্চিত..',
    'YES': 'হ্যাঁ',
    'NO': 'না',
    'Something went wrong. Please try again.':
        'কিছু সমস্যা বিদ্যমান। অনুগ্রহপূর্বক আবার চেষ্টা করুন।',
    '01xxxxxxxxx': '০১*********',
    'AM': 'দিন',
    'PM': 'রাত',

    // Numbers
    '.': '.',
    '-': '-',
    ':': ':',
    '/': '/',
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
