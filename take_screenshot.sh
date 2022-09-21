#!/bin/bash

# ADB Screenshot 1.0
# File:         take_screenshot.sh
# Author:       Thomas Qvidahl 2022
# Description:  This script will format a filename and location for a screenshot taken from
#               an adb attached device, physical or emulator. Files will be chronologically named
#               for easy sorting. It will attempt to locate your adb installation, but if
#               unsuccessful, you can enter it manually in the script.
#               If there is more than one device available, you will be asked to provide
#               its serial number. This can be done conveniently once, by setting the
#               $ANDROID_SERIAL env var.
#               Also great potential for improvement, consider this a good start...

# Configure this to your liking:
FOLDER=~/screenrecordings
FILENAMESUFFIX=myscreenshot
# If the script is unable to locate your adb installation this way, you may have to provide it manually:
ADB_LOCATION=$(which adb)

# And if you want to customize further, also change this:
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
FILENAME=$FOLDER/$TIMESTAMP-$FILENAMESUFFIX.png

# This is needed to know if there is more than one device
DEVICES=$($ADB_LOCATION devices | wc -l | xargs)

helpFunction()
{
   echo ""
   echo "More than one device is active:"
   echo ""
   adb devices
   echo "Either set the names as environment variable ANDROID_SERIAL, or"
   echo "supply it as a command line parameter"
   exit 1 # Exit script after printing help
}

echo "Creating screenshot $FILENAME"
if [ "$DEVICES" -gt 3 ]
then
  if [ "$1" != "" ]
  then
    echo "Using device $1"
    $ADB_LOCATION -s $1 exec-out screencap -p>$FILENAME
    exit 0
  elif [ "$ANDROID_SERIAL" != "" ]
  then
    echo "More than one device attached, using environment variable ANDROID_SERIAL=$ANDROID_SERIAL"
    $ADB_LOCATION -s $ANDROID_SERIAL exec-out screencap -p>$FILENAME
    exit 0
  else
    helpFunction
  fi
else
  echo "Using the active device..."
  $ADB_LOCATION exec-out screencap -p>$FILENAME
  exit 0
fi
