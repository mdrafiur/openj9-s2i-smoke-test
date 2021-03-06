#!/bin/sh

# Execute 'setup' script if the directory to store test results has not been created.
setup_environment() {
    if [[ ! -d ~/test-results ]]
    then
        ./setup.sh
    fi
}

# Read and parse argList file to extract platform/build info
parse_args() {
    IFS=':'
    read -r JDK_VERSION RHEL_VERSION BUILD_VERSION < argList.txt
    IFS='-'
    read -a versions <<< "$BUILD_VERSION"
    IFS='!'
}

# Runs the test
run_test() {
    setup_environment
    parse_args

    SOURCE_IMAGE="registry-proxy.engineering.redhat.com/rh-osbs/openj9-openj9-$JDK_VERSION-rhel$RHEL_VERSION:$BUILD_VERSION"
    TARGET_IMAGE="openj9/openj9-$JDK_VERSION-rhel$RHEL_VERSION:$versions"
    
    docker pull $SOURCE_IMAGE
    docker tag $SOURCE_IMAGE $TARGET_IMAGE
    # Removes 'openjdk' directory if already exists
    if [[ -d ./openjdk ]]
    then
        rm -rf openjdk
    fi
    # git clone https://github.com/jboss-container-images/openjdk
    git clone --branch openj9-0.26.0 https://github.com/mdrafiur/openjdk.git
    mv openjdk ~/openj9-$JDK_VERSION-rhel$RHEL_VERSION
    cd ~
    source cekit/bin/activate
    cd ~/openj9-$JDK_VERSION-rhel$RHEL_VERSION
    nohup cekit --descriptor ./openj9-$JDK_VERSION-rhel$RHEL_VERSION.yaml test behave &> ~/test-results/smokeTest-$JDK_VERSION-rhel$RHEL_VERSION.log
}

run_test
