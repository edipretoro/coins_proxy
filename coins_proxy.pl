#!/usr/bin/env perl

use strict;
use warnings;

use HTTP::Proxy;
use HTTP::Proxy::BodyFilter::complete;
use HTTP::Proxy::BodyFilter::simple;

use HTML::TreeBuilder::XPath;
use Data::Dump qw( dump );

use URI;
use URI::QueryParam;

my $proxy = HTTP::Proxy->new( @ARGV );

$proxy->push_filter(
    mime => 'text/html',
    response => HTTP::Proxy::BodyFilter::complete->new(),
    response => HTTP::Proxy::BodyFilter::simple->new(
        sub {
            my ( $self, $dataref, $message, $protocol, $buffer ) = @_;

            my $tree = HTML::TreeBuilder::XPath->new_from_content( $$dataref );
            my $coins_xpath = '//span[@class="Z3988"]';

            my $coins = $tree->findnodes( $coins_xpath );

            my $coins_title_xpath = './@title';
            foreach (@$coins) {
                my $coins_title = $_->findvalue( $coins_title_xpath );
                
                # This part will be updated when I'll find a OpenURL resolver
                my $uri = URI->new( 'http://www.bib.ulb.ac.be' . '?' . $coins_title );
                my $params = $uri->query_form_hash();
                my $issn = $params->{'rft.issn'};
                my $link_uri = URI->new( 'http://bib7.ulb.ac.be/uhtbin/ISSN/' . $issn);
                my $link = HTML::Element->new( 'a', href => $link_uri->as_string );
                $link->push_content('ZOZO');
                $_->push_content( $link );
                # End of this part
            }

            $$dataref = $tree->as_HTML;
        }        
    ),
);

$proxy->start;

