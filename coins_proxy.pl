#!/usr/bin/perl -w

use strict;
use warnings;

use HTTP::Proxy;

my $proxy = HTTP::Proxy->new( @ARGV );



$proxy->start;

