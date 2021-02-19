#!/bin/sh
docker pull registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-8-rhel8:1.2-10
docker tag registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-8-rhel8:1.2-10 openj9/openj9-8-rhel8:1.2
git clone https://github.com/jboss-container-images/openjdk
mv openjdk ~/openj9-8-rhel8
cd ~
source cekit/bin/activate
cd ~/openj9-8-rhel8
cekit --descriptor ./openj9-8-rhel8.yaml test behave &> ~/test-results/smokeTest-8-rhel8.log
