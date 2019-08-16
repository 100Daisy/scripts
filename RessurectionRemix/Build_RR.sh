# Variables
API_KEY="<changeme>"
CHAT_ID="<changeme>"
MEGA_EMAIL="<changeme>"
MEGA_PASSWORD="<changeme>"
BUILD_TYPE="<changeme>"
DATE=`date +%m%d`

# Time Measure START
SECONDS=0

# Use CCACHE
echo "export USE_CCACHE=1" >> ~/.bashrc
~/RR/prebuilts/misc/linux-x86/ccache/ccache -M 25G

# Build RessurectionRemix for Daisy
cd ~/RR
export days_to_log=0
export WITHOUT_CHECK_API=true
export SKIP_BOOT_JARS_CHECK=true
. build/envsetup.sh && lunch rr_deen-$BUILD_TYPE
time mka

# Count Time
ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

# Compress images into zip (eng only only)
cd ~/RR/out/target/product/deen
zip RessurectionRemix-$DEVICE-$DATE.zip system.img boot.img

# MEGA (Publishing)
mega-login $MEGA_EMAIL $MEGA_PASSWORD
SECONDS=0
mega-put RessurectionRemix-deen-$DATE.zip deen
UPLOAD="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

# Telegram (Annoucment)
curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID -d text="Build finished in:$ELAPSED %0AUpload time: $UPLOAD %0ADownload Link: https://mega.nz/#F!iHBXiIgC!4wZy9dFCN7T-0XtSWAdknQ"
