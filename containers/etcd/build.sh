#!/bin/bash
set -e
ROOT=$(dirname $(readlink -f "$0"))

source ${ROOT}/../../config.sh
source ${ROOT}/prj.sh

# Prepare a fake base image
if [ ! -f ${ROOT}/rootfs.tar.gz ]; then
  cp -v ${ROOT}/../Dockerfile .
  cp -v ${ROOT}/../../output/images/rootfs.tar.gz .
fi
docker build -t ${FAKE_IMG} .

# Remove unused line in Dockerfile
sed -i.back "/ADD etcd/d" ${ORIG_PRJ}/${ORIG_DOCKERFILE}

# Start to build original image
pushd . > /dev/null 2>&1
cd ${ORIG_PRJ}
docker build -t ${REGISTRY}/${ORIG_IMG}:${TAG} -f ./${ORIG_DOCKERFILE} .
popd > /dev/null 2>&1

echo "Generate ${REGISTRY}/${ORIG_IMG}:${TAG} done"
