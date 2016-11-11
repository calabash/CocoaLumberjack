#!/usr/bin/env bash

source bin/log-functions.sh
source bin/copy-with-ditto.sh

if [ -z "${FBSIMCONTROL_PATH}" ]; then
  if [ -e "../FBSimulatorControl" ]; then
    FBSIMCONTROL_PATH="../FBSimulatorControl"
  fi
fi

if [ ! -d "${FBSIMCONTROL_PATH}" ]; then
  error "FBSimulatorControl does not exist at path:"
  error "  ${FBSIMCONTROL_PATH}"
  error "Set the FBSIMCONTROL_PATH=path/to/FBSimulatorControl or"
  error "checkout the calabash fork of the FBSimulatorControl repo to ../"
  exit 1
fi

make macos-framework

banner "Installing to FBSimulatorControl/Vendor"

SOURCE="Products/macOS/CocoaLumberjack.framework"
TARGET="${FBSIMCONTROL_PATH}/Vendor/CocoaLumberjack.framework"

ditto_or_exit "${SOURCE}" "${TARGET}"

info "Installed ${TARGET}"

