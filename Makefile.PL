#!/usr/bin/perl
# $Id: Makefile.PL,v 1.6 2005/05/18 11:52:58 pelagic Exp $
use strict;

use ExtUtils::MakeMaker;

eval "use Test::Manifest";

unless( $@ )
    {
    * ExtUtils::MM_Any::test_via_harness = sub
        {
        my($self, $perl, $tests) = @_;

        return qq|\t$perl "-MTest::Manifest" |
             . qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', |
             . qq|'\$(INST_ARCHLIB)')"\n|;
        }
    }

WriteMakefile(
    'NAME'          => 'List::Rotation',
    'VERSION_FROM'  => 'Rotation.pm',

    'PREREQ_PM'     => { 'Test::More'   => '0', },

    'MAN3PODS'      => { 'Rotation.pm'  => '$(INST_MAN3DIR)/List::Rotation.3', },
    'clean'         => { FILES          => 'List-Rotation-*' },
);

