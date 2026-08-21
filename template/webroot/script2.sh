#!/system/bin/sh
GLOBAL_HEADER='{
  "configVersion": 93,
  "detailLog": false,
  "errorOnlyLog": false,
  "maxLogSize": 512,
  "forceMountData": true,
  "disableActivityLaunchProtection": false,
  "altAppDataIsolation": false,
  "altVoldAppDataIsolation": false,
  "skipSystemAppDataIsolation": true,
  "packageQueryWorkaround": false,
  "templates": {},
  "settingsTemplates": {},
  "scope": {'
APP_RULE_TEMPLATE='  "%s": {
    "useWhitelist": false,
    "excludeSystemApps": true,
    "hideInstallationSource": false,
    "hideSystemInstallationSource": false,
    "excludeTargetInstallationSource": false,
    "invertActivityLaunchProtection": false,
    "excludeVoldIsolation": false,
    "restrictedZygotePermissions": [],
    "applyTemplates": [],
    "applyPresets": ["detector_apps","root_apps","shizuku_dhizuku","sus_apps","xposed"],
    "applySettingTemplates": [],
    "applySettingsPresets": ["dev_options"],
    "extraAppList": [],
    "extraOppositeAppList": []
  }'
EXCLUDED_PACKAGES="eu.darken.sdmse me.weishu.kernelsu bin.mt.plus.canary bin.mt.plus org.telegram.messenger org.telegram.group me.bmax.apatch com.omarea.vtools"
FIXED_TARGET_PACKAGES="com.android.vending
com.google.android.gms
io.github.vvb2060.keyattestation
io.github.vvb2060.mahoshojo
icu.nullptr.nativetest
com.reveny.nativecheck
com.zhenxi.hunter
io.github.qwq233.keyattestation
com.android.nativetest
io.liankong.riskdetector
luna.safe.luna"
OUTPUT_FILE="/data/user/0/org.frknkrc44.hma_oss/files/config.json"
EXCLUDE_REGEX=$(echo "$EXCLUDED_PACKAGES" | sed 's/ /|/g')
ALL_USER_PACKAGES=$(pm list packages -3 | sed 's/^package://' | grep -v -E "$EXCLUDE_REGEX")
FIRST_ENTRY=1
SCOPE_CONTENT=""
for PKG_NAME in $ALL_USER_PACKAGES; do
    if [ $FIRST_ENTRY -eq 1 ]; then
        SCOPE_CONTENT=$(printf "$APP_RULE_TEMPLATE" "$PKG_NAME")
        FIRST_ENTRY=0
    else
        SCOPE_CONTENT="$SCOPE_CONTENT,
$(printf "$APP_RULE_TEMPLATE" "$PKG_NAME")"
    fi
done
FULL_CONFIG="$GLOBAL_HEADER
$SCOPE_CONTENT
}}"
printf "%s" "$FULL_CONFIG" > "$OUTPUT_FILE"
am start --user 0 -n org.frknkrc44.hma_oss/.MainActivityLauncher > /dev/null 2>&1
sleep 1
input keyevent 4
exit 0