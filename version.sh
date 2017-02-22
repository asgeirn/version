#!/bin/bash

VERSION=$(git log --oneline | nl -nln | perl -lne 'if (/^(\d+).*Version (\d+\.\d+\.\d+)/) { print "$2-$1"; exit; }')

if [[ ".$VERSION" != "." ]]
then
    echo Setting version to $VERSION
    mvn versions:set -DnewVersion=$VERSION -DgenerateBackupPoms=false
else
    echo No version number found.
fi
