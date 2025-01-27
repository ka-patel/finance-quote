#!/usr/bin/perl -w

# A test script to check for working of the alpaca_crypto module.

use strict;
use Test::More;
use Finance::Quote;

if (not $ENV{ONLINE_TEST}) {
    plan skip_all => 'Set $ENV{ONLINE_TEST} to run this test';
}

plan tests => 10;

my $q = Finance::Quote->new();

# List of crypto to fetch. Feel free to change this during testing.
# Must be in the following format (USD is only supported currency of 01/27/25):
#   <CRYPTO_SYMBOL>/<ISO_CURRENCY_NAME>
my @cryptos =
    ( "ETH/USD", "BTC/USD" );

my %quotes = $q->fetch( "alpaca_crypto", @cryptos );
ok( %quotes, "Data returned" );

foreach my $crypto (@cryptos) {

    my $name = $quotes{ $crypto, "name" };
    ok( $quotes{ $crypto, "success" }, "Retrieved $crypto" );
    if ( !$quotes{ $crypto, "success" } ) {
        my $errmsg = $quotes{ $crypto, "errormsg" };
        warn "Error Message:\n$errmsg\n";
    }
    else {
        my $fetch_method = $quotes{ $crypto, "method" };
        ok( $fetch_method eq 'alpaca_crypto', "fetch_method is alpaca_crypto" );

        my $last = $quotes{ $crypto, "last" };
        ok( $last > 0, "Last $last > 0" );

        my $volume = $quotes{ $crypto, "volume" };
        ok( $volume >= 0, "Volume $volume >= 0" );

        #TODO: Add a test to raise a warning if the quote is excessively old
        my $isodate = $quotes{ $crypto, "isodate" };

        # print "ISOdate: $isodate ";
        my $date = $quotes{ $crypto, "date" };

        # print "Date: $date ";
    }
}

# Check that a bogus crypto returns no-success.
%quotes = $q->fetch( "alpaca_crypto", "BTC/BOGUS" );
ok( !$quotes{ "BOGUS", "success" }, "BOGUS failed" );
