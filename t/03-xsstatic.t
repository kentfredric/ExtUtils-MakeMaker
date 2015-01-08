#!/usr/bin/perl -w

use strict;
use warnings;
use Config;
BEGIN {
    chdir 't' or die "chdir(t): $!\n";
    unshift @INC, 'lib/';
}
use MakeMaker::Test::Utils;
use MakeMaker::Test::Setup::XS;
use Test::More;

plan skip_all => "ExtUtils::CBuilder not installed or couldn't find a compiler"
  unless have_compiler();
plan skip_all => 'Shared perl library' if $Config{useshrplib} eq 'define';
plan skip_all => 'MSWin32' if $^O eq 'MSWin32';
plan skip_all => 'Cygwin' if $^O eq 'cygwin';
my @tests = list_static();
plan skip_all => "No tests" unless @tests;
plan tests => 6 * @tests;
my $perl = which_perl();
perl_lib;
$| = 1;
run_tests($perl, @$_) for @tests;