#!/bin/sh
docker pull registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-8-rhel7:1.1-22
docker tag registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-8-rhel7:1.1-22 openj9/openj9-8-rhel7:1.1
git clone https://github.com/jboss-container-images/openjdk
mv openjdk ~/openj9-8-rhel7
cd ~
source cekit/bin/activate
cd ~/openj9-8-rhel7
cekit --descriptor ./openj9-8-rhel7.yaml test behave &> ~/test-results/smokeTest-8-rhel7.log
