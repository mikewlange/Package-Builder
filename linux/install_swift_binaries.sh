#!/bin/bash

##
# Copyright IBM Corporation 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

# This script installs the Swift binaries. The following variable
# must be set for this script to work:
#   SWIFT_SNAPSHOT - version of the Swift binaries to install.

# If any commands fail, we want the shell script to exit immediately.
set -e

# Echo commands before executing them.
set -o verbose

sudo apt-get update
#sudo apt-get -y install clang-3.8 lldb-3.8 libicu-dev libtool libcurl4-openssl-dev libbsd-dev build-essential libssl-dev uuid-dev # does not work on Bluemix DevOps Pipeline, using regular clang install instead
sudo apt-get -y install clang lldb-3.8 libicu-dev libtool libcurl4-openssl-dev libbsd-dev build-essential libssl-dev uuid-dev

# Remove default version of clang from PATH
#export PATH=`echo ${PATH} | awk -v RS=: -v ORS=: '/clang/ {next} {print}'`

# Set clang 3.8 as default - does not work on Bluemix DevOps Pipeline, using regular clang install instead
#sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100
#sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100

# Environment vars
version=`lsb_release -d | awk '{print tolower($2) $3}'`
export UBUNTU_VERSION=`echo $version | awk -F. '{print $1"."$2}'`
export UBUNTU_VERSION_NO_DOTS=`echo $version | awk -F. '{print $1$2}'`

echo ">> Installing '${SWIFT_SNAPSHOT}'..."
# Install Swift compiler
cd $projectFolder
wget https://swift.org/builds/$SNAPSHOT_TYPE/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
export PATH=$projectFolder/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/bin:$PATH
rm $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
swiftc -h
