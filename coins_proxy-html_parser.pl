#!/usr/bin/perl -w

use strict;
use warnings;

use HTTP::Proxy;
use HTTP::Proxy::BodyFilter::complete;
use HTTP::Proxy::BodyFilter::htmlparser;
use HTML::Parser;
use URI;
use URI::QueryParam;

my $parser = HTML::Parser->new( api_version => 3 );

$parser->handler(
    start => sub {
        my ($self, $tagname, $attr, $attrseq, $text) = @_;
        
        if ($tagname eq 'span' && $attr->{class} eq 'Z3988') {
            # Must be updated when OpenURL resolver was found
            my $uri = URI->new( 'http://www.bib.ulb.ac.be' . '?' . $attr->{title} );
            my $params = $uri->query_form_hash();
            my $issn = $params->{'rft.issn'};
            my $link_uri = URI->new( 'http://bib7.ulb.ac.be/uhtbin/ISSN/' . $issn);
            my $coins_text = '<a href="' . $link_uri->as_string . '">ZOZO</a>';
            # End of the 'must be updated' code

            $text .= $coins_text;
        }
        $self->{output} .= $text;
    }, "self, tagname, attr, attrseq, text",
);

$parser->handler(
    default => sub {
        my ($self, $text) = @_;
        $self->{output} .= $text;
    }, "self,text",
);

my $proxy = HTTP::Proxy->new( @ARGV );

$proxy->push_filter(
    mime => 'text/html',
    response => HTTP::Proxy::BodyFilter::complete->new(),
    response => HTTP::Proxy::BodyFilter::htmlparser->new( $parser, rw => 1 ),
);

$proxy->start;

