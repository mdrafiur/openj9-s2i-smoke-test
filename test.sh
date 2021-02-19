#!/bin/sh
if [ ! -d "~/test-results" ]
then
  setup.sh
fi
IFS=':'
read -r JDK_VERSION RHEL_VERSION BUILD_VERSION < argList.txt
IFS='-'
read -a versions <<< "$BUILD_VERSION"
sed -i "s|docker pull.*|docker pull registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-$JDK_VERSION-rhel$RHEL_VERSION:$BUILD_VERSION|" testScripts/smoke-test-openj9-$JDK_VERSION-rhel$RHEL_VERSION.sh
sed -i "s|docker tag.*|docker tag registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-$JDK_VERSION-rhel$RHEL_VERSION:$BUILD_VERSION openj9/openj9-$JDK_VERSION-rhel$RHEL_VERSION:$versions|" testScripts/smoke-test-openj9-$JDK_VERSION-rhel$RHEL_VERSION.sh
nohup sh testScripts/smoke-test-openj9-$JDK_VERSION-rhel$RHEL_VERSION.sh