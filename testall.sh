#!/bin/sh
# executes the 'setup.sh' script to perform the initial system setup
./setup.sh

# iterates the 'testScripts' directory and runs all four openj9 s2i image test scripts
for script in testScripts/*.sh
do
    nohup sh "$script"
done
