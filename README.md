# Automatic versioning based on Git log

One of [Praqma's Continuous Delivery](http://www.praqma.com/training/code-kickstart/) recommendations 
is to always produce versioned artifacts.

There are of course many strategies for doing so, but I've found it easier to not depend on too many 
external assumptions or tools when doing so.

So I've advocated a strategy where the version number is taken from the Git log, but a release (or build)
number is automatically added.

The gist of it is like this:

    git log --oneline | nl -nln | perl -lne 'if (/^(\d+).*Version (\d+\.\d+\.\d+)/) { print "$2-$1"; exit; }

Let's take it step by step:

    git log --oneline

This one produces this familiar output:

    28361f0 Minor update.
    1e7dc11 Version 1.0.0
    2dfda94 Initial version.

Then add the `nl` command:

    1   28361f0 Minor update.
    2   1e7dc11 Version 1.0.0
    3   2dfda94 Initial version.

This just numbers thet lines, beginning with one.

The magic happens in the Perl filter:

    if (/^(\d+).*Version (\d+\.\d+\.\d+)/)

This one looks for a line containing the string `Version` and three dot-separated numbers; a [SemVer](http://semver.org/) version number.  It captures this version number, as well as the number produced by `nl`.

It then combines these:

    print "$2-$1";

For the little log above, it would produce `1.0.0-2`, version 1.0.0 as declared in the Git log, but the second build from that version.

For Maven projects, the [Versions](http://www.mojohaus.org/versions-maven-plugin/) plugin can be used to set the version number prior to the build.

So this is what we do:

1. The POM in the Git repository is always set at `0-SNAPSHOT`
2. As a pre-build step, the `version.sh` script is executed
3. Then the build is run as normal.

Step two can for instance take the following form:

    wget https://raw.githubusercontent.com/asgeirn/version/master/version.sh | bash

If you're concerned of someone pushing a rogue version of this script that does `rm -rf /` instead, you could link directly to a specific commit instead:

    wget https://raw.githubusercontent.com/asgeirn/version/4532adf6465302b0d5af39f26dcaca8cb19bfd42/version.sh | bash


