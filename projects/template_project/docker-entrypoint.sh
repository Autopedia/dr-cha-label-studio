#!/bin/bash
label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
-l config.xml \
-c project_config.json \
--sampling uniform \
--log-level INFO \
--use-gevent