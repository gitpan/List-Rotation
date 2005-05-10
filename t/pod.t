# $Id: pod.t,v 1.2 2005/05/06 13:34:19 pelagic Exp $
use Test::More;
eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
all_pod_files_ok();
