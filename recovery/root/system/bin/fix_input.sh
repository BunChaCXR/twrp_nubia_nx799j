#!/system/bin/sh
# Recovery on fox_16.0 is stricter about input_device access than TWRP.
setenforce 0 2>/dev/null
# OrangeFox binds the first ABS_MT-looking input device; on sun the fingerprint /
# haptic / SAR nodes register early and can be mistaken for the touchscreen.
# Blacklist them by name so minui falls through to the real touch panel.
for e in /sys/class/input/event*; do
    n="$(cat "$e/device/name" 2>/dev/null)"
    case "$n" in
        *goodix*|*hbtp*|*sar*|*Headset*|*Jack*)
            ev="/dev/input/$(basename "$e")"
            chmod 000 "$ev" 2>/dev/null ;;
    esac
done
chmod 0770 /dev/input 2>/dev/null
for ev in /dev/input/event*; do
    chown system input "$ev" 2>/dev/null
    chmod 0660 "$ev" 2>/dev/null
done
