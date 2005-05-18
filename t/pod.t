#!/usr/bin/perl
# $Id: pod.t,v 1.2 2005/05/18 10:48:43 pelagic Exp $
use strict;

use Test::More;
eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
all_pod_files_ok();
