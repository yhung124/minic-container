ORIG_PRJ="etcd"
ORIG_DOCKERFILE="Dockerfile-release"
FAKE_IMG="$(cat ${ORIG_PRJ}/${ORIG_DOCKERFILE} | grep 'FROM' | cut -d ' ' -f 2)"
TAG="$(git --git-dir=${ORIG_PRJ}/.git describe --tags)"
ORIG_IMG="etcd"

