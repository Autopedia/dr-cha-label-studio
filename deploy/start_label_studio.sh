#!/usr/bin/env bash
# see deploy/uwsgi.ini for details
# /usr/local/bin/uwsgi --ini /label-studio/deploy/uwsgi.ini
echo "Copy google credentials.."
export GOOGLE_APPLICATION_CREDENTIALS="./dingbro-ai-storage.json"

echo "Make simple Label Studio launch..."
label-studio