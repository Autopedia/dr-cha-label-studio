#!/usr/bin/env bash
# see deploy/uwsgi.ini for details
# /usr/local/bin/uwsgi --ini /label-studio/deploy/uwsgi.ini
echo "Make simple Label Studio launch..."
label-studio start --username $LABEL_STUDIO_USERNAME --password $LABEL_STUDIO_PASSWORD
