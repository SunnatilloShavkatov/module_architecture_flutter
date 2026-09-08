#!/bin/bash

set -e

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get the project root directory (one level up from scripts/)
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Change to project root
cd "$PROJECT_ROOT"

echo "🧼 Cleaning and getting dependencies..."
flutter clean && flutter pub get && flutter pub upgrade

# Process modules
MODULES_DIR="$PROJECT_ROOT/modules"
if [ -d "$MODULES_DIR" ]; then
  echo "📦 Scanning modules in $MODULES_DIR"
  for module in "$MODULES_DIR"/*; do
    if [ -d "$module" ] && [ -f "$module/pubspec.yaml" ]; then
      MODULE_NAME=$(basename "$module")
      echo ""
      echo "🔍 Processing module: $MODULE_NAME"
      echo "⬆️  Running pub upgrade for $MODULE_NAME"
      (
        cd "$module"
        flutter pub upgrade
      )
    fi
  done
fi

# Process packages
PACKAGES_DIR="$PROJECT_ROOT/packages"
if [ -d "$PACKAGES_DIR" ]; then
  echo ""
  echo "📦 Scanning packages in $PACKAGES_DIR"
  for package in "$PACKAGES_DIR"/*; do
    if [ -d "$package" ] && [ -f "$package/pubspec.yaml" ]; then
      PACKAGE_NAME=$(basename "$package")
      echo ""
      echo "🔍 Processing package: $PACKAGE_NAME"
      echo "⬆️  Running pub upgrade for $PACKAGE_NAME"
      (
        cd "$package"
        flutter pub upgrade
      )
    fi
  done
fi

echo ""
echo "✅ All modules and packages upgraded and processed successfully!"
