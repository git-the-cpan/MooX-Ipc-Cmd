#!/usr/bin/perl -w
use strict;
use Test::More tests => 24;
use Config;
package test;
use Moo;
use MooX::Options;
with qw(MooX::Ipc::Cmd);
1;

package main;


# We want to invoke our sub-commands using Perl.
my $test=test->new;

my $perl_path = $Config{perlpath};

if ($^O ne 'VMS') {
	$perl_path .= $Config{_exe}
		unless $perl_path =~ m/$Config{_exe}$/i;
}

chdir("t");	# Ignore return, since we may already be in t/

$test->_system([$perl_path,"exiter.pl",0]);

ok(1,"Multi-arg system");

$test->_system(["$perl_path exiter.pl 0"]);
ok(1,"Single-arg system success");

foreach my $exit (1..5,250..255) {

	eval {
		$test->_system([$perl_path,"exiter.pl",$exit]);
	};

	is($@->exit_status, $exit , "Multi-arg system fail $exit");
}

# Single arg tests


foreach my $exit (1..5,250..255) {

	eval {
		$test->_system(["$perl_path exiter.pl $exit"]);
	};

	is($@->exit_status, $exit,"Single-arg system fail, exit $exit" );
}
1;
