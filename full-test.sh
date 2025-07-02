#!/bin/bash
# This script automates testing for assignment-autotest
set -e
export FORCE_UNSAFE_CONFIGURE=1
export SKIP_BUILD=1
export DO_VALIDATE=1


cd "$(dirname "$0")"
test_dir=$(pwd)
echo "starting test with SKIP_BUILD=\"${SKIP_BUILD}\" and DO_VALIDATE=\"${DO_VALIDATE}\""

logfile=test.sh.log
exec > >(tee -i -a "$logfile") 2> >(tee -i -a "$logfile" >&2)

echo "Running test with user $(whoami)"
pwd


set +e

if [ -f conf/assignment.txt ]; then
    assignment=$(cat conf/assignment.txt)

    if [ -f ./assignment-autotest/test/${assignment}/assignment-test.sh ]; then
        echo "Executing assignment test script"
        ./assignment-autotest/test/${assignment}/assignment-test.sh "$test_dir"
        rc=$?

        if [ $rc -eq 0 ]; then
            echo "Test of assignment ${assignment} complete with success"
            exit 0
        else
            echo "Test of assignment ${assignment} failed with rc=${rc}"
            exit $rc
        fi
    else
        echo "No assignment-test script found for ${assignment}"
        exit 1
    fi
else
    echo "Missing conf/assignment.txt, no assignment to run"
    exit 1
fi
