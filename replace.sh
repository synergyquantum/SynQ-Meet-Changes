#!/bin/bash

CONTAINER_NAME="docker-jitsi-meet-stable-9457-2-web-1"

# Replace the images
echo "Copying images..."
docker cp logo-deep-linking-mobile.png "$CONTAINER_NAME":/usr/share/jitsi-meet/images/
docker cp watermark.svg "$CONTAINER_NAME":/usr/share/jitsi-meet/images/
docker cp welcome-background.png "$CONTAINER_NAME":/usr/share/jitsi-meet/images/

echo "Copying additional files..."
docker cp title.html "$CONTAINER_NAME":/usr/share/jitsi-meet/
docker cp app.bundle.min.js "$CONTAINER_NAME":/usr/share/jitsi-meet/libs/
docker cp lib-jitsi-meet.min.js "$CONTAINER_NAME":/usr/share/jitsi-meet/libs/

echo "Replacing headerTitle in JSON files..."
docker exec "$CONTAINER_NAME" bash -c "
  cd /usr/share/jitsi-meet/lang/ && 
  find . -name '*.json' -exec sed -i 's/\"headerTitle\": *\"[^\"]*\"/\"headerTitle\": \"SynQ Meet\"/g' {} +
"

echo "Updating JITSI_WATERMARK_LINK in interface_config.js..."
docker exec "$CONTAINER_NAME" bash -c "
  sed -i '/JITSI_WATERMARK_LINK:/s/.*/    JITSI_WATERMARK_LINK: \"\",/' /config/interface_config.js
"

echo "Updating APP_NAME in interface_config.js..."
docker exec "$CONTAINER_NAME" bash -c "
  sed -i '/APP_NAME:/s/.*/    APP_NAME: \"SynQ Meet\",/' /config/interface_config.js
"
