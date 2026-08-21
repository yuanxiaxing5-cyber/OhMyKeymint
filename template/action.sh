#!/system/bin/sh
echo "正在生成完整包名配置..."
T=/data/adb/omk/omkdata/injector.tmp
OUT=/data/adb/omk/omkdata/injector.toml
BASE_SCOOP_RAW="io.github.vvb2060.keyattestation
io.github.qwq233.keyattestation
wu.keyChain.test
com.google.android.gsf
com.google.android.gms
com.android.vending
com.eltavine.duckdetector"
THIRD_PARTY=$(pm list packages -3 | sed 's/^package://')
ALL_SCOOP=$(printf "%s\n%s" "$BASE_SCOOP_RAW" "$THIRD_PARTY" | sort -u | grep -v '^$')
> "$T"
cat > "$T" <<'EOF'
version = 1
scoop = [
EOF
echo "$ALL_SCOOP" | sed 's/^/    "/;s/$/",/' >> "$T"
cat >> "$T" <<'EOF'
]
[main]
enabled = true
log_level = "error"

[filter]
enabled = true
deny_packages = []
block_android_package = true
allow_unknown_package = false
[intercept]
get_security_level = true
get_key_entry = true
update_subcomponent = true
list_entries = true
delete_key = true
grant = true
ungrant = true
get_number_of_entries = true
list_entries_batched = true
get_supplementary_attestation_info = true
EOF

mv "$T" "$OUT"
chmod 644 "$OUT"
toybox chown system "$OUT"
echo "✅包名列表配置成功"
