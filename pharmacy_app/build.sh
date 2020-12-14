# Build APK and IOS
# STATION MEANS THE FOLDER WHICH HAS ALL THE PROJECT FILES AND .git FOLDER

echo "REMOVING OLD APKs"
rm -r ../appfolder
mkdir ../appfolder

printf "\n"

echo "BUILDING Pharmacy APK"
flutter clean
flutter build apk
cp ./build/app/outputs/apk/release/app-release.apk ./build/app/outputs/apk/release/pharmacy.apk
echo "COPYING NEW Pharmacy APK TO ONE DIRECTORY BACK OF STATION"
cp ./build/app/outputs/apk/release/Pharmacy.apk ../appfolder
echo "Pharmacy APK DONE AND BUILT SUCCESSFULLY"



















