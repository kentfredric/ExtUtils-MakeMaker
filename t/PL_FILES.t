#!/usr/bin/perl -w

BEGIN {
    unshift @INC, 't/lib';
}

use strict;

use File::Spec;
use File::Temp qw[tempdir];
use MakeMaker::Test::Setup::PL_FILES;
use MakeMaker::Test::Utils;
use Config;
use ExtUtils::MM;
use Test::More
    !MM->can_run(make()) && $ENV{PERL_CORE} && $Config{'usecrosscompile'}
    ? (skip_all => "cross-compiling and make not available")
    : (tests => 9);

my $perl = which_perl();
my $make = make_run();
chdir 't';
perl_lib; # sets $ENV{PERL5LIB} relative to t/

my $tmpdir = tempdir( DIR => '../t', CLEANUP => 1 );
use Cwd; my $cwd = getcwd; END { chdir $cwd } # so File::Temp can cleanup
chdir $tmpdir;

setup;

END {
    ok( chdir File::Spec->updir );
    ok( teardown );
}

ok chdir('PL_FILES-Module');

run(qq{$perl Makefile.PL});
cmp_ok( $?, '==', 0 );

my $make_out = run("$make");
is( $?, 0 ) || diag $make_out;

foreach my $file (qw(single.out 1.out 2.out blib/lib/PL/Bar.pm)) {
    ok( -e $file, "$file was created" );
}
