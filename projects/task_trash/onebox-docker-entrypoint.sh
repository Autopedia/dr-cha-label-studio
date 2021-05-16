#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="../../.credential/dingbro-garbage-crawling.json"
export PROJECT_NAME=task_trash_onebox
export PORT=9000

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--username dingbro --password qwer1234 \
-l onebox-config.xml \
-c project_config.json \
--sampling sequential \
--log-level INFO \
--force \
--source gcs --source-path garbage_v2 \
--source-params "{\"use_blob_urls\": true, \"data_key\": \"image\", \"prefix\": \"data4ls/selectstar_1026_bbox/images\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \
--target gcs-completions --target-path garbage_v2 \
--target-params "{\"prefix\": \"data4ls/selectstar_1026_bbox/outputs\", \"create_local_copy\": false}" \
--use-gevent