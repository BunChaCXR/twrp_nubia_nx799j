#!/system/bin/sh
# Persist a diagnostic snapshot to the persist partition so it survives a reboot
# and can be picked up from Android via /persist (no touch/log-reading needed).
D=/mnt/vendor/persist
mkdir -p $D 2>/dev/null
mount -t ext4 -o rw /dev/block/bootdevice/by-name/persist $D 2>/dev/null
mount -o rw,remount /persist 2>/dev/null
OUT=$D/twrp_diag.log
i=0
while [ $i -lt 60 ]; do
    {
        echo "=== tick $i $(date)"
        echo "--- init.svc"
        getprop | grep init.svc
        echo "--- crypto props"
        getprop | grep -i crypto
        echo "--- input devices"
        cat /proc/bus/input/devices 2>/dev/null
        ls -lZ /dev/input 2>/dev/null
        echo "--- recovery.log tail"
        tail -60 /tmp/recovery.log 2>/dev/null
    } > $OUT.tmp 2>&1
    mv $OUT.tmp $OUT 2>/dev/null
    if [ -f /persist/twrp_diag.log ]; then cp $OUT /persist/twrp_diag.log 2>/dev/null; fi
    i=$((i+1))
    sleep 5
done
