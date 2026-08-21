#!/system/bin/sh
echo "正在更新包名列表..."
T=/data/adb/omk/omkdata/injector.toml
FIX="io.github.vvb2060.keyattestation
com.google.android.gsf
com.google.android.gms
com.android.vending
com.eltavine.duckdetector"
ALL=$(printf "%s\n%s" "$FIX" "$(pm list packages -3 | sed 's/^package://')" | sort -u | grep -v '^$')
S=$(grep -n '^scoop = \[' $T | head -1 | cut -d: -f1)
E=$(grep -n '^\]' $T | head -1 | cut -d: -f1)

{
sed -n "1,$((S-1))p" $T
echo "scoop = ["
echo "$ALL" | sed 's/^/    "/;s/$/",/'
echo "]"
sed -n "$((E+1)),\$p" $T
} > ${T}.tmp && mv ${T}.tmp $T
echo "✅配置应用包名成功"
