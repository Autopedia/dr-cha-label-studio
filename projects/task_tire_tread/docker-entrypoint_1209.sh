#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="../../.credential/doctorcha-ai.json"
export PROJECT_NAME=task_tire_tread_1209
export PORT=8007

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--username dingbro --password qwer1234 \
-l config.xml \
--source gcs --source-path tire-tread-dataset \
--source-params "{\"use_blob_urls\": true, \"prefix\": \"1209/images\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \
-c project_config.json \
--sampling uniform \
--log-level INFO \
--force \
--target gcs-completions --target-path tire-tread-dataset \
--target-params "{\"prefix\": \"1209/outputs\"}" \
--use-gevent
