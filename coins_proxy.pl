#!/usr/bin/perl -w

use strict;
use warnings;

use HTTP::Proxy;
use HTTP::Proxy::BodyFilter::complete;
use HTTP::Proxy::BodyFilter::simple;

my $proxy = HTTP::Proxy->new( @ARGV );

$proxy->push_filter(
    mime => 'text/html',
    response => HTTP::Proxy::BodyFilter::complete->new(),
    response => HTTP::Proxy::BodyFilter::simple->new(
        sub {
            my ( $self, $dataref, $message, $protocol, $buffer ) = @_;

            
        }        
    ),
);

$proxy->start;

