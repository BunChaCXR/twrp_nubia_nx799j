#!/system/bin/sh
# Runs at 'on init', before recovery/minui scans /dev/input.
# OrangeFox binds the first ABS-capable input node; on sun the fingerprint /
# haptic / SAR nodes register early and get mistaken for the touchscreen.
setenforce 0 2>/dev/null
i=0
while [ $i -lt 6 ]; do
    for e in /sys/class/input/event*; do
        [ -e "$e" ] || continue
        n="$(cat "$e/device/name" 2>/dev/null)"
        case "$n" in
            *goodix*|*hbtp*|*sar*|*Headset*|*Jack*)
                chmod 000 "/dev/input/$(basename "$e")" 2>/dev/null ;;
        esac
    done
    for ev in /dev/input/event*; do
        [ -e "$ev" ] || continue
        chown system input "$ev" 2>/dev/null
        chmod 0660 "$ev" 2>/dev/null
    done
    chmod 0770 /dev/input 2>/dev/null
    i=$((i+1))
    sleep 1
done
