#!/bin/sh
docker pull registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-11-rhel8:1.2-16
docker tag registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-11-rhel8:1.2-16 openj9/openj9-11-rhel8:1.2
git clone https://github.com/jboss-container-images/openjdk
mv openjdk ~/openj9-11-rhel8
cd ~
source cekit/bin/activate
cd ~/openj9-11-rhel8
cekit --descriptor ./openj9-11-rhel8.yaml test behave &> ~/test-results/smokeTest-11-rhel8.log