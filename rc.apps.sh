#!/bin/bash

# Delete all old apps and rc.apps.json
rm -rfv apps_d
rm -rfv *.rc-app.zip
rm -rfv rc.apps.json
rm -rfv apps_list
#
echo "#################################################################################"
echo "Downloads Rocket.Chat Marketplace apps list"
echo "#################################################################################"
curl https://marketplace.rocket.chat/v1/apps > rc.apps.json
echo ""
ls -hl rc.apps.json
echo ""
echo "Download is complete."
echo ""
# Get all app names
cat rc.apps.json | jq -r '.[].latest.nameSlug' > apps_list
APP_LIST='apps_list'
echo ""
echo "#################################################################################"
echo "Start downloading apps."
echo "#################################################################################"
# Download apps
while read app_name;
do
  # find app_id
  app_id="$(cat rc.apps.json| jq '.[] | select(any(.latest; .nameSlug == "'$app_name'")) | .appId' | cut -d \" -f2)"
  echo "App ID for $app_name is $app_id"
  echo "Downloading $app_name app."
  # curl apps into zip files
  curl -L https://marketplace.rocket.chat/v1/apps/$app_id/download > $app_name.rc-app.zip
  echo ""
  echo "#################################################################################"
done < $APP_LIST
echo "#################################################################################"
# Move all apps to separate directory
mkdir -v apps_d
mv *.rc-app.zip ./apps_d
# List the downloaded apps via zip files.
ls -lh ./apps_d/*.rc-app.zip
echo "#################################################################################"
echo "Enable developer mode in Rocket.Chat setting."
echo "Upload the app_name .zip file you want to use."
echo "#################################################################################"
