#!/bin/bash
export DISPLAY=":0.0"
BATTERY_STATE=$(acpi -b | awk '{print $3}' | tr -d '%,')
BATTERY_LEVEL=$(acpi -b | awk '{print $4}' | tr -d '%,')
BATTERY_CRITICAL_THRESHOLD=75

echo "Battery Level : ${BATTERY_LEVEL}"
echo "Battery State : ${BATTERY_STATE}"
if [[ $BATTERY_STATE != "Discharging" ]]; then
	echo "Currently Charging, Exiting Script"
	exit 0
fi

if [ $BATTERY_LEVEL -lt $BATTERY_CRITICAL_THRESHOLD ]; then
	# Checking if warning already exist or not
	if [ -z $(pgrep i3-nagbar) ]; then
		echo "Nagbar is not running"
	else
		echo "Nagbar already exist, exiting script..."
		exit 0
	fi
	notify-send "$BATTERY_LEVEL % Remaining"
    i3-nagbar -m "Battery is Critical, Please Charge The Battery" &
fi