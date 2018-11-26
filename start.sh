#!/bin/bash
set +e

#ENV variables
GIT_TEST_REPO="https://github.com/Jinggit/web-regressiontest-demo.git"
GIT_REPO_NAME="web-regressiontest-demo"
TEST_SCRIPT="."
DEFAULT_PATH="/home/root/test"

echo 'Starting Xvfb ...'
export DISPLAY=:99
2>/dev/null 1>&2 Xvfb :99 -shmem -screen 0 1920x1200x16 &
exec "$@"

mkdir -p $DEFAULT_PATH
cd $DEFAULT_PATH

echo 'Cloning test repo...'
git clone $GIT_TEST_REPO


echo 'Starting robot tests...'
cd $DEFAULT_PATH/$GIT_REPO_NAME
pybot --outputdir ../logs --exclude notready $DEFAULT_PATH/$GIT_REPO_NAME/$TEST_SCRIPT
