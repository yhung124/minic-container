#!/bin/bash
set -e
ROOT=$(dirname $(readlink -f "$0"))

source ${ROOT}/../../config.sh
source ${ROOT}/prj.sh

echo -e "Start to push ${ORIG_IMG}\n"

docker push ${REGISTRY}/${ORIG_IMG}:${TAG}
#docker push ${REGISTRY}/${ORIG_IMG}:${REL_TAG}

echo -e "Push ${REGISTRY}/${ORIG_IMG}:${TAG} done\n"
#echo -e "Push ${REGISTRY}/${ORIG_IMG}:${REL_TAG} done\n"
