#!/usr/bin/env bash

source bin/log-functions.sh
source bin/copy-with-ditto.sh

if [ "${XCPRETTY}" = "0" ]; then
  USE_XCPRETTY=
else
  USE_XCPRETTY=`which xcpretty | tr -d '\n'`
fi

if [ ! -z ${USE_XCPRETTY} ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

XC_PROJECT="Lumberjack.xcodeproj"
XC_TARGET="CocoaLumberjack"
XC_CONFIG=Release
BUILD_DIR=build/macOS
INSTALL_DIR=Products/macOS
FRAMEWORK_NAME=CocoaLumberjack.framework

SOURCE="${BUILD_DIR}/${XC_CONFIG}/${FRAMEWORK_NAME}"
TARGET="${INSTALL_DIR}/${FRAMEWORK_NAME}"

rm -rf "${BUILD_DIR}"
mkdir "${BUILD_DIR}"
rm -rf "${INSTALL_DIR}"
mkdir "${INSTALL_DIR}"

banner "Making macOS Framework"

xcrun xcodebuild \
  SYMROOT="${BUILD_DIR}" \
  OBJROOT="${BUILD_DIR}" \
  -project ${XC_PROJECT} \
  -target ${XC_TARGET} \
  -configuration ${XC_CONFIG} \
  -sdk macosx \
  GCC_TREAT_WARNINGS_AS_ERRORS=NO \
  GCC_GENERATE_TEST_COVERAGE_FILES=NO \
  GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO \
  build | $XC_PIPE

info "Built ${SOURCE}"

ditto_or_exit "${SOURCE}" "${TARGET}"

info "Installed ${TARGET}"
