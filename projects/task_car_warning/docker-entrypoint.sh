#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="../../.credential/doctorcha-ai.json"
export PROJECT_NAME=task_car_warning
export PORT=6000

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--username dingbro --password qwer1234 \
-l config.xml \
-c project_config.json \
--sampling uniform \
--log-level INFO \
--force \
--source gcs --source-path car-warning-sign \
--source-params "{\"use_blob_urls\": true, \"data_key\": \"image\", \"prefix\": \"1202/images\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \
--target gcs-completions --target-path car-warning-sign \
--target-params "{\"prefix\": \"1202/outputs\", \"create_local_copy\": false}" \
--use-gevent