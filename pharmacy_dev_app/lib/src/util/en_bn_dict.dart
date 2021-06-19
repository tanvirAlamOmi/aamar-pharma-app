import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:intl/intl.dart';

class EnBnDict {
  static String en_bn_convert({String text}) {
    if(text == null) return '';
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
    if (Store.instance.appState.language == ClientEnum.LANGUAGE_ENGLISH) {
      return text;
    }
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

    // Tutorial
    'You can order medicines or other items by simply uploading a photo of your prescription or a photo of a paper with your item list on it or even just a photo of the items':
        'প্রেসক্রিপশন অথবা আইটেমের তালিকার ছবি, এমনকি শুধু আইটেমের ছবি আপলোড করে  আপনি খুব সহজেই ওষুধ অথবা অন্যান্য আইটেম অর্ডার করতে পারবেন।',
    'You can also order by adding the name of the items you want to order and stating their unit and quantity manually':
        'ম্যানুয়্যালি আইটেমের নাম সংযুক্ত করে ইউনিট এবং পরিমাণ উল্লেখ করার মাধ্যমেও আপনি অর্ডার পাঠাতে পারবেন।”',
    'Call us on our hotline number anytime between 10 AM to 10 PM for any kind of queries you have':
        'আপনার যেকোনো জিজ্ঞাসার জন্য আমাদের হটলাইনে কল করুন সকাল ১০টা থেকে রাত ১০টার মধ্যে যেকোনো সময়।',
    'Always click here to get all the information of your orders':
        'আপনার অর্ডারসমূহের সমস্ত তথ্য পেতে সর্বদা এখানে ক্লিক করুন ',
    'The items you add will be listed under this':
        'যে আইটেমগুলো আপনি যুক্ত করবেন তা এর নিচে তালিকাভুক্ত হবে।',
    'Tap to remove this uploaded photo':
        'আপলোডকৃত এই ছবিটি রিমোভ করতে এখানে চাপুন',
    'Add the address of the place you would like to get your order delivered to':
        'যেখানে অর্ডারের ডেলিভারি পেতে চান সেই ঠিকানাটি যুক্ত করুন।',
    'Select the address you would want this particular order to get delivered to. Selected address will have Green Border':
        'এই অর্ডারটি যে ঠিকানায় ডেলিভারি পেতে চান সেই ঠিকানাটি নির্বাচন করুন। নির্বাচিত ঠিকানায় সবুজ বর্ডার থাকবে।',
    'This indicates the current status of your order':
        'এটি আপনার অর্ডারের বর্তমান অবস্থা নির্দেশ করে।',
    'View your list of orders by specific order status':
        'নির্ধারিত অর্ডার স্ট্যাটাসের মাধ্যমে আপনার অর্ডারসমূহ ফিল্টার করুন।',
    'Request a product by adding the name, photo, quantity and short notes about the product':
        'কোনো দ্রব্যের অনুরোধ জানাতে দ্রব্যটির নাম, ছবি, পরিমাণ এবং তা সম্পর্কে শর্ট নোট যুক্ত করুন',
    'Tap to add a new order you would like to get delivered multiple times on a regular basis':
        'একই অর্ডার নির্দিষ্ট সময় পর পর ডেলিভারি পেতে এটিতে চাপুন।',
    'This states the date you’ll have this order delivered next':
        'এটা এই অর্ডারের পরবর্তী ডেলিভারির তারিখ নির্দেশ করে।',
    'Tap this if you want to order the same items again':
        'আপনি যদি আবার একই আইটেম অর্ডার করতে চান তবে এটিতে চাপুন',
    'View your order details to check if we got the correct item list':
        'আমরা সঠিক আইটেমের তালিকা পেয়েছি কিনা তা দেখতে আপনার অর্ডার বৃত্তান্তটি দেখুন ',
    'Tap to remove items from the list if you don’t want to order it':
        'আপনি যদি এই আইটেমটি না চান তবে তালিকা থেকে এটি সরাতে এখানে চাপুন',
    'Plus or minus the quantity of items':
        'আইটেমের পরিমাণ বাড়াতে বা কমাতে এই বাটনে চাপুন',
    'Upload a picture of your prescription or have your prescription ready upon delivery':
        'আপনার প্রেসক্রিপশনের ছবি আপলোড করুন বা ডেলিভারির সময় আপনার প্রেসক্রিপশন প্রস্তুত রাখুন',

    // Bottom Navigation Bar
    'Home': 'হোম',
    'Orders': 'অর্ডারসমূহ',
    'Account': 'একাউন্ট',

    // Drop Down Filter Card
    'SORT BY ORDER STATUS / ALL': 'অর্ডারের অবস্থা অনুযায়ী দেখুন / সকল অর্ডার',
    'Pending': 'প্রক্রিয়াধীন অর্ডারসমূহ',
    'Invoice sent': 'চালান দেয়া হয়েছে এমন অর্ডারসমূহ',
    'Confirmed': 'নিশ্চিত করা হয়েছে এমন অর্ডারসমূহ',
    'Delivered': 'ডেলিভারি সম্পন্ন হয়েছে এমন অর্ডারসমূহ',
    'Canceled': 'ক্যান্সেল করা হয়েছে এমন অর্ডারসমূহ',
    'Rejected': 'রিজেক্ট করা হয়েছে এমন অর্ডারসমূহ',
    'PENDING': 'প্রক্রিয়াধীন',
    'INVOICE SENT': 'চালান দেয়া হয়েছে',
    'CONFIRMED': 'নিশ্চিত করা হয়েছে',
    'DELIVERED': 'ডেলিভারি সম্পন্ন হয়েছে',
    'CANCELED': 'ক্যান্সেল করা হয়েছে',
    'REJECTED': 'রিজেক্ট করা হয়েছে',

    //Order Invoice Address Card
    'INVOICE TOTAL': 'মোট',

    //Notify On Delivery Area Card
    'We are currently delivering in:': 'বর্তমানে ডেলিভারির আওতাধীন এলাকাসমূহ:',
    'Don\'t have your area in our delivering area list?':
        'আমাদের ডেলিভারির তালিকায় আপনার এলাকা নেই?',
    'Want us to notify you when we do?': 'আমরা যখন করব তখন আপনাকে জানিয়ে দিবো?',
    'Area*': 'এলাকা*',
    'Mirpur, Banani...': 'মিরপুর, বনানী...',
    'YES, NOTIFY ME': 'হ্যাঁ, আমাকে জানাবেন',

    // Order Card
    'Order ID: ': 'অর্ডার ক্রমিক নং: ',
    'Delivery: ': 'ডেলিভারি: ',

    // Repeat Order Card
    'NEXT DELIVERY ON': 'পরবর্তী ডেলিভারি',

    // Repeat Order Page Button Card
    'ADD A NEW REPEAT ORDER': 'নতুন রিপিট অর্ডার করুন',
    'YOU CAN CANCEL ANYTIME': 'যেকোনো সময় ক্যান্সেল করুন',

    //Order Invoice Address Card
    'Collect prescription during delivery':
        'ডেলিভারির সময় প্রেসক্রিপশন সংগ্রহ করুন',
    'Prescription(s) selected': 'টি প্রেসক্রিপশন নির্বাচন করা হয়েছে',

    // Time Choose Button
    'SELECT DELIVERY TIME': 'ডেলিভারি টাইম নির্ধারণ করুন',
    'OK': 'ঠিক আছে',
    'Please select a time between 10 AM to 10 PM':
        'অনুগ্রহপূর্বক সকাল ১০টা থেকে রাত ১০টার মধ্যেকার কোন একটা সময়  করুন',

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

    // Notification Page
    'NOTIFICATIONS': 'নোটিফিকেশন',

    // Upload Prescription Verify Page
    'UPLOAD PRESCRIPTION': 'প্রেসক্রিপশন আপলোড',
    'UPLOADED PHOTO(s)': 'টি আপলোডকৃত ছবি',
    'Add Notes': 'নোট/নির্দেশনা যুক্ত করুন',
    'Notes e.g. I need all the medicines': 'উদাঃ আমার সবগুলো ওষুধ প্রয়োজনীয়',
    '1 image is mandatory for the prescription':
        'প্রেসক্রিপশনের জন্য অন্তত একটি ছবি আবশ্যক',
    'CONFIRM': 'নিশ্চিত',

    //Add Items Page
    'ADD ITEMS': 'আইটেম যুক্ত করুন ',
    'Item Name': 'আইটেমের নাম',
    'Napa': 'নাপা',
    'Unit': 'একক',
    'mg/ml': 'মি,গ্রা/এমএল ',
    'Quantity': 'পরিমাণ',
    'e.g. 10,15': 'উদাঃ ১০,১৫ ',
    'ADD ITEM': 'আইটেম যোগ করুন ',
    'ADDED ITEMS': 'আপনার আইটেমসমূহ',
    'QUANTITY: ': 'পরিমাণ: ',
    'pieces': 'পিস',
    'box': 'বক্স',
    'strip': 'পাতা',

    // Confirm Order Page
    'CONFIRM ORDER': 'অর্ডার নিশ্চিত করুন',
    'DELIVERY TIME (EVERYDAY 10 AM TO 10 PM)':
        'ডেলিভারির সময় (প্রতিদিন সকাল ১০টা থেকে রাত ১০টা)',
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
    'NAME*': 'নাম*',
    'EMAIL': 'ইমেইল',
    'Phone Number*': 'ফোন নাম্বার*',
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
    'UPLOADED PRESCRIPTION(s)': 'টি প্রেসক্রিপশন আপলোড',

    // Request Received Success Page
    'ORDER RECEIVED': 'অর্ডার গ্রহণ',
    'Your order has been placed.': 'আপনার অর্ডারটি গৃহীত হয়েছে',
    'We will get back to you within 30 minutes.':
        '৩০ মিনিটের মধ্যে আপনার সাথে যোগাযোগ করা হবে।',
    'ORDER AND INVOICE CONFIRMED': 'অর্ডার এবং চালান গ্রহণ',
    'Your order and invoice is confirmed.':
        'আপনার অর্ডার এবং চালান গৃহীত হয়েছে',
    'We will get back to you as soon as possible.':
        'অতি দ্রুত আপনার সাথে যোগাযোগ করা হবে।',
    'REQUEST RECEIVED': 'অনুরোধ গ্রহণ',
    'Your request has been received.': 'আপনার অনুরোধটি গৃহীত হয়েছে',
    'You will get a call back within 30 minutes.':
        '৩০ মিনিটের মধ্যে আপনার সাথে যোগাযোগ করা হবে।',
    'We will notify you when we have your requested product.':
        'আপনার প্রয়োজনীয় পণ্যটির ব্যবস্থাপূর্বক আপনাকে জানানো হবে।',

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
    'Verifying Code...': 'কোড যাচাই করা হচ্ছে...',

    // My Details Page
    'MY DETAILS': 'আমার বৃত্তান্ত',
    'SAVE': 'সেইভ করুন',
    'Please fill all the information': 'অনুগ্রহপূর্বক সবগুলো ঘর পূর্ণ করুন',
    'Please provide phone number': 'অনুগ্রহপূর্বক ফোনের ঘর পূর্ণ করুন',
    'Please provide your name': 'অনুগ্রহপূর্বক নামের ঘর পূর্ণ করুন',
    'Updated user': 'আপনার ব্যক্তিগত তথ্য পরিবর্তন করা হল।',

    // Order Details Page
    'ORDER DETAILS': 'অর্ডার বৃত্তান্ত',
    'Email': 'ইমেইল',
    'DELIVERY ADDRESS': 'ডেলিভারি ঠিকানা',
    'CANCEL ORDER': 'অর্ডার ক্যান্সেল করুন',
    'Are you sure to cancel this order?':
        'আপনি কি এই অর্ডারটি ক্যান্সেল করতে চাচ্ছেন?',

    // Help & FAQ Page
    'FAQs': 'সচরাচর জিজ্ঞাস্য',
    'HOW IT WORKS': 'এটি কিভাবে কাজ করে?',
    '1. Place your prescription or item list, and wait a while. \n\n'
            '2. Pharmacy starts preparing your medicine just after you place an order.\n\n'
            '3. One of our troopers takes your medicine safely and drives to your home.\n\n'
            '4. You take the delivery having no anxiety of safety.\n':
        '১. আপনার প্রেসক্রিপশন বা আইটেমের তালিকা দেয়ার পর কিছুক্ষণ অপেক্ষা করুন। \n\n'
            '২. অর্ডার দেয়ার পরে ফার্মাসি আপনার ওষুধ প্রস্তুত করা শুরু করে। \n\n'
            '৩. তারপর আমরা আপনার ওষুধটি নিরাপদে নিয়ে আপনার বাড়িতে ডেলিভারি দিব। \n\n'
            '৪. আপনি নিরাপত্তার কোনও উদ্বেগ ছাড়াই ডেলিভারিটি গ্রহণ করতে পারবেন। \n',
    'Do you take delivery charges?': 'আপনারা কি ডেলিভারি চার্জ রাখেন?',
    'We only take BDT 20 as the delivery charges for the orders below 500.':
        'শুধু ৫০০ টাকার কম মূল্যের অর্ডারের জন্য আমরা ২০ টাকা ডেলিভারি চার্জ রাখি।',
    'Can I select the pharmacy?': 'আমি কি ফার্মেসি নির্বাচন করতে পারবো?',
    'No. It’s an automated process. Our software does the task.':
        'না। এটি একটি স্বয়ংক্রিয় প্রক্রিয়া। আমাদের সফটওয়্যার এই কাজটি করে।',
    'How do you select the pharmacy?': 'আপনারা ফার্মেসি নির্বাচন করেন কীভাবে?',
    'It’s automatically selected by the distance and availability.':
        'দূরত্ব এবং উপযোগিতা অনুযায়ী এটি স্বয়ংক্রিয়ভাবে নির্বাচিত হয়।',
    'Do you take very large or small orders?':
        'আপনারা কি খুব বড় বা ছোট অর্ডার গ্রহণ করেন?',
    'Yes. We pay the same attention for every delivery.':
        'হ্যাঁ। প্রতিটি ডেলিভারির ক্ষেত্রে  আমরা সমান মনোযোগ দিয়ে থাকি।',
    'Do you courier medicines to other cities?':
        'আপনারা কি অন্য শহরে ওষুধ কুরিয়ার করেন?',
    'No. We have selected areas where we can reach fast.':
        'না। আমাদের কিছু নির্ধারিত এলাকা আছে যেখানে আমরা দ্রুত পৌঁছাতে পারি।',
    'Do you have other options of order except the app?':
        'এপ ছাড়া অর্ডার করার আর কোনো বিকল্প ব্যবস্থা রয়েছে?',
    'No. You have to order from the app.': 'না। আপনার এপ থেকে অর্ডার করতে হবে।',
    'Do you have emergency customer support?':
        'আপনাদের কি জরুরি গ্রাহক সেবা রয়েছে?',
    'Yes. Call +8801874761111 for customer support from 10 am to 10 pm.':
        'হ্যাঁ। গ্রাহক সেবার জন্য +৮৮০১৮৭৪৭৬১১১১ নাম্বারে সকাল ১০টা থেকে রাত ১০টার মধ্যে কল করুন।',
    'Do you deliver medicines without prescription?':
        'আপনারা কি প্রেসক্রিপশন ছাড়া ওষুধের ডেলিভারি করেন?',
    'We only deliver OTC (Over the Counter) medicines without prescription.':
        'আমরা শুধু ওটিসি (ওভার দ্য কাউন্টার) ওষুধগুলো প্রেসক্রিপশন ছাড়া ডেলিভারি দিয়ে থাকি।',
    'Do you check the expiration date?':
        'আপনারা কি মেয়াদোত্তীর্ণ হওয়ার তারিখ চেক করেন?',
    'Yes. We check the expiration date before taking the medicines from the pharmacy.':
        'হ্যাঁ। ফার্মেসি থেকে ওষুধ গ্রহন করার পূর্বে আমরা মেয়াদোত্তীর্ণ হওয়ার তারিখ চেক করি।',
    'Can I save my order in the app?':
        'আমি কি আমার অর্ডার এপে সংরক্ষণ করে রাখতে পারবো?',
    'It’s automatically saved when you place an order. You can repeat it whenever you want.':
        'আপনি অর্ডার করার পর তা স্বয়ংক্রিইয় ভাবেই সংরক্ষিত হয়। আপনি যখন চাইবেন তখন অর্ডার রিপিট করতে পারবেন।',

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
    'Discount': 'ডিস্কাউন্ট',
    'Delivery Fee': 'ডেলিভারি ফী',
    'Total': 'মোট',
    'Are you sure to confirm this invoice for this order?':
        'আপনি কি এই অর্ডারটির জন্য এই চালান এবং দামের বিষয়টি নিশ্চিত করেছেন?',
    'CANCEL REPEAT ORDER': 'অর্ডারের পুনরাবৃত্তি বন্ধ করুন',
    'Are you sure to stop this repeat order?':
        'এই অর্ডারের পুনরাবৃত্তি বন্ধ করে দিতে চাচ্ছেন?',
    'Repeat Order is cancelled': 'অর্ডারের পুনরাবৃত্তি বন্ধ হয়েছে।',
    'Order is cancelled': 'অর্ডারটি ক্যান্সেল করা হয়েছে।',
    'Order is confirmed.': 'অর্ডারটি নিশ্চিত করা হয়েছে।',
    'Confirming Order and Invoice...': 'অর্ডার এবং চালান নিশ্চিত করা হচ্ছে...',
    'Confirming...': 'নিশ্চিত করা হচ্ছে...',
    'You can not remove the last item': 'শেষের আইটেমটি রিমুভ করা যাবে না',
    'Please upload the required prescriptions':
        'প্রয়োজনীয় প্রেসক্রিপশন আপলোড করুন',
    '*Prescription required': '*প্রেসক্রিপশন আবশ্যক',

    // Order Final Invoice Page
    'ORDER INVOICE DETAILS': 'অর্ডার চালান',
    'REORDER': 'পুনরায় এই অর্ডার করুন',
    'Invoice Number': 'চালান ক্রমিক নং',
    'Date Of Issue': 'চালানের তারিখ',
    'Billed to': 'বিল',
    'DONE': 'সম্পন্ন',
    'Do you want to get this order delivered on a regular basis?':
        'আপনি কি এই অর্ডারটি নিয়মিত পেতে চান?',
    'Have the order delivered without having to order it again and again':
        'বারবার অর্ডার না করেই অর্ডারটি পেয়ে যান',
    'YES, REPEAT THIS ORDER': 'অর্ডারটি পুনরাবৃত্তি করুন',
    'NO THANKS': 'এখন প্রয়োজন নেই',

    // Repeat Order Choice Page
    'REPEAT ORDER': 'অর্ডার পুনরাবৃত্তি',
    'Please select the interval and time you would like to get this order delivered on regular basis':
        'অনুগ্রহপূর্বক কতদিন পর পর অর্ডারটি চাচ্ছেন তা ঠিক করুন',
    'Deliver every': 'ডেলিভারি প্রতি',
    'Day(s)': 'দিন পর পর',
    'Select Time': 'সময়',
    'Processing...': 'প্রসেস করা হচ্ছে...',
    'Repeat order submission success.': 'অর্ডার পুনরাবৃত্তি গৃহীত হয়েছে।',

    // Special Request Product Page
    'REQUEST A PRODUCT': 'পণ্যের আবেদন জানান',
    'REQUEST PRODUCT': 'পণ্যের আবেদন',
    'ADD PHOTO': 'ছবি যুক্ত করুন',
    'Are you sure to submit this request?':
        'আপনি কি এই পণ্যের আবেদন করতে নিশ্চিত?',
    'Please provide the name of the item': 'পণ্যের নাম আবশ্যক',
    'Please provide the quantity of the item': 'পণ্যের পরিমাণ আবশ্যক',
    'Phone Number': 'মোবাইল নাম্বার',

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
    '+': '+',
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
