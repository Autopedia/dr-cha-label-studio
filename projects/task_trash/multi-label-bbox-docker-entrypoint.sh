#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="../../.credential/dingbro-garbage-crawling.json"
export PROJECT_NAME=task_multi_label_bbox
export PORT=9001

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--username dingbro --password qwer1234 \
-l multi-label-bbox-config.xml \
-c project_config.json \
--sampling uniform \
--log-level INFO \
--force \
--source gcs --source-path garbage_v2 \
--source-params "{\"use_blob_urls\": true, \"data_key\": \"image\", \"prefix\": \"data4ls/1112/images\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \
--target gcs-completions --target-path garbage_v2 \
--target-params "{\"prefix\": \"data4ls/1112/outputs_2\", \"create_local_copy\": false}" \
--use-gevent