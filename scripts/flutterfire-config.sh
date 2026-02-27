#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors
# Feel free to reuse and adapt this script for your own projects
if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev' or 'prod'."
  exit 1
fi
case $1 in
  dev)
    flutterfire config \
      --project=sample-562f9 \
      --out=lib/config/firebase_options_dev.dart \
      --ios-bundle-id=uz.shs.moduleArchitectureMobile.dev \
      --ios-out=ios/config/dev/GoogleService-Info.plist \
      --android-package-name=uz.shs.module_architecture_mobile.dev \
      --android-out=android/app/src/dev/google-services.json
    ;;
  prod)
    flutterfire config \
      --project=sample-562f9 \
      --out=lib/config/firebase_options_prod.dart \
      --ios-bundle-id=uz.shs.moduleArchitectureMobile \
      --ios-out=ios/config/prod/GoogleService-Info.plist \
      --android-package-name=uz.shs.module_architecture_mobile \
      --android-out=android/app/src/prod/google-services.json
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev' or 'prod'."
    exit 1
    ;;
esac
