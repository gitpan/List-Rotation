#!/usr/bin/perl
#$Id: pod-coverage.t,v 1.2 2005/05/18 10:48:43 pelagic Exp $
use strict;

use Test::More;
eval "use Test::Pod::Coverage 0.08";
plan skip_all => "Test::Pod::Coverage 0.08 required for testing POD coverage" if $@;
all_pod_coverage_ok();
