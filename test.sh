#!/bin/sh

# Execute 'setup' script if the directory to store test results has not been created.
if [ ! -d "~/test-results" ]
then
  sh setup.sh
fi

# Read and parse argList file to extract platform/build info
IFS=':'
read -r JDK_VERSION RHEL_VERSION BUILD_VERSION < argList.txt
IFS='-'
read -a versions <<< "$BUILD_VERSION"
# sed -i "s|docker pull.*|docker pull registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-$JDK_VERSION-rhel$RHEL_VERSION:$BUILD_VERSION|" testScripts/smoke-test-openj9-$JDK_VERSION-rhel$RHEL_VERSION.sh
# sed -i "s|docker tag.*|docker tag registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-$JDK_VERSION-rhel$RHEL_VERSION:$BUILD_VERSION openj9/openj9-$JDK_VERSION-rhel$RHEL_VERSION:$versions|" testScripts/smoke-test-openj9-$JDK_VERSION-rhel$RHEL_VERSION.sh
# nohup sh testScripts/smoke-test-openj9-$JDK_VERSION-rhel$RHEL_VERSION.sh
# Runs the test
docker pull registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-$JDK_VERSION-rhel$RHEL_VERSION:$BUILD_VERSION
docker tag registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-$JDK_VERSION-rhel$RHEL_VERSION:$BUILD_VERSION openj9/openj9-$JDK_VERSION-rhel$RHEL_VERSION:$versions
git clone https://github.com/jboss-container-images/openjdk
mv openjdk ~/openj9-$JDK_VERSION-rhel$RHEL_VERSION
cd ~
source cekit/bin/activate
cd ~/openj9-$JDK_VERSION-rhel$RHEL_VERSION
cekit --descriptor ./openj9-$JDK_VERSION-rhel$RHEL_VERSION.yaml test behave &> ~/test-results/smokeTest-$JDK_VERSION-rhel$RHEL_VERSION.log