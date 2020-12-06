# Build APK and IOS
# STATION MEANS THE FOLDER WHICH HAS ALL THE PROJECT FILES AND .git FOLDER

echo "REMOVING OLD APKs"
rm -r ../appfolder
mkdir ../appfolder

printf "\n"

echo "BUILDING FOS APK"
flutter clean
flutter build apk
cp ./build/app/outputs/apk/release/app-release.apk ./build/app/outputs/apk/release/fos.apk
echo "COPYING NEW FOS APK TO ONE DIRECTORY BACK OF STATION"
cp ./build/app/outputs/apk/release/fos.apk ../appfolder
echo "FOS APK DONE AND BUILT SUCCESSFULLY"



















