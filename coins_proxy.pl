#!/usr/bin/perl -w

use strict;
use warnings;

use HTTP::Proxy;
use HTTP::Proxy::BodyFilter::complete;
use HTTP::Proxy::BodyFilter::simple;

use HTML::TreeBuilder::XPath;
use Data::Dump qw( dump );

my $proxy = HTTP::Proxy->new( @ARGV );

$proxy->push_filter(
    mime => 'text/html',
    response => HTTP::Proxy::BodyFilter::complete->new(),
    response => HTTP::Proxy::BodyFilter::simple->new(
        sub {
            my ( $self, $dataref, $message, $protocol, $buffer ) = @_;

            my $tree = HTML::TreeBuilder::XPath->new_from_content( $$dataref );
            my $coins_xpath = '//span[@class="Z3988"]/@title';

            my $coins = $tree->findvalue( $coins_xpath );
            print "The COinS is " . $coins . "\n";
        }        
    ),
);

$proxy->start;

