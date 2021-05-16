#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="../../.credential/dingbro-ai.json"
export PROJECT_NAME=task_credit_card
export PORT=7500

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--username dingbro --password qwer1234 \
-l config.xml \
-c project_config.json \
--sampling uniform \
--log-level INFO \
--force \
--source gcs --source-path credit-card-dataset \
--source-params "{\"use_blob_urls\": true, \"data_key\": \"image\", \"prefix\": \"0202/images\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \
--target gcs-completions --target-path credit-card-dataset \
--target-params "{\"prefix\": \"0202/outputs\", \"create_local_copy\": false}" \
--use-gevent