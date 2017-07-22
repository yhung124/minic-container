#!/bin/sh
set -e

# Bash
cp -v ${BR2_EXTERNAL_MINIC_CONTAINER_PATH}/board/common/bashrc ${TARGET_DIR}/root/.bashrc
