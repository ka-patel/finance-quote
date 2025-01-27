#!/usr/bin/perl -w
# vi: set ts=2 sw=2 ic noai showmode showmatch:  

#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
#    02110-1301, USA

#    Copyright (C) 2023, Bruce Schuck <bschuck@asgard-systems.com>

package Finance::Quote::CurrencyRates::FXRatesAPI;

use strict;
use warnings;

use constant DEBUG => $ENV{DEBUG};

use if DEBUG, 'Smart::Comments', '###';

use JSON;

# VERSION

sub new
{
  my $self = shift;
  my $class = ref($self) || $self;

  my $this = {};
  bless $this, $class;

  my $args = shift;

  ### FXRatesAPI->new args : $args

  return $this;
}

sub multipliers
{
  my ($this, $ua, $from, $to) = @_;

  # Also works as of 01-27-2025:
  # my $reply = $ua->get('https://api.fxratesapi.com/convert?from=' . $from . '&to=' . $to . '&format=JSON&places=8&amount=1',);
  my $reply = $ua->get('https://api.fxratesapi.com/latest?format=JSON&base=' . $from);
  
  my $body = $reply->content;
  my $reply_code = $reply->code;

  return unless ($reply_code == 200);

  my $json_data = decode_json ($body);

#   {
#   "success": true,
#   "terms": "https://fxratesapi.com/legal/terms-conditions",
#   "privacy": "https://fxratesapi.com/legal/privacy-policy",
#   "timestamp": 1737995340,
#   "date": "2025-01-27T16:29:00.000Z",
#   "base": "EUR",
#   "rates": {
#     "EUR": 1,
#     "ADA": 1.134967001,
#     "AED": 3.856923741,
#     "AFN": 82.650733942,
#     "ALL": 97.989415501,
#     "AMD": 418.090630594,
#     "ANG": 1.877031551,
#     "AOA": 961.113470318,
#     "ARB": 1.656335526,
#     "ARS": 1102.494576933,
#     "AUD": 1.672066564,
#     "AWG": 1.880508646,
#     "AZN": 1.785957932,
#     "BAM": 1.955162011,
#     "BBD": 2.101126979,
#     "BDT": 128.199255676,
#     "BGN": 1.946326791,
#     "BHD": 0.395011872,
#     "BIF": 3062.712290048,
#     "BMD": 1.05056349,
#     "BNB": 0.001577443,
#     "BND": 1.41096998,
#     "BOB": 7.276928914,
#     "BRL": 6.22141721,
#     "BSD": 1.05056349,
#     "BTC": 1.043e-05,
#     "BTN": 89.671541446,
#     "BWP": 14.505889398,
#     "BYN": 3.435561202,
#     "BYR": 34355.60630905,
#     "BZD": 2.101126979,
#     "CAD": 1.5112043,
#     "CDF": 2990.956841947,
#     "CHF": 0.945696372,
#     "CLF": 0.026516225,
#     "CLP": 1036.168836232,
#     "CNY": 7.617101035,
#     "COP": 4435.788004528,
#     "CRC": 530.982077446,
#     "CUC": 1.05056349,
#     "CUP": 25.213523749,
#     "CVE": 110.087834178,
#     "CZK": 25.075503838,
#     "DAI": 1.050158041,
#     "DJF": 186.707193924,
#     "DKK": 7.463435353,
#     "DOP": 64.6191106,
#     "DOT": 0.179581979,
#     "DZD": 141.807863928,
#     "EGP": 52.766671044,
#     "ERN": 15.758452343,
#     "ETB": 132.646511862,
#     "ETH": 0.000336594,
#     "FJD": 2.453024091,
#     "FKP": 0.8416381,
#     "GBP": 0.841806148,
#     "GEL": 3.021410688,
#     "GGP": 0.841638331,
#     "GHS": 15.922983251,
#     "GIP": 0.841638177,
#     "GMD": 76.224808559,
#     "GNF": 9092.162096207,
#     "GTQ": 8.10368013,
#     "GYD": 219.396988775,
#     "HKD": 8.178375587,
#     "HNL": 26.785800392,
#     "HRK": 7.126288266,
#     "HTG": 139.363267629,
#     "HUF": 408.779455906,
#     "IDR": 16976.08213528,
#     "ILS": 3.796117057,
#     "IMP": 0.841638395,
#     "INR": 90.680027535,
#     "IQD": 1374.692013509,
#     "IRR": 44133.37237482,
#     "ISK": 145.823270239,
#     "JEP": 0.841638366,
#     "JMD": 164.877512184,
#     "JOD": 0.745900078,
#     "JPY": 162.01538802,
#     "KES": 135.93770965,
#     "KGS": 92.046274716,
#     "KHR": 4215.336058025,
#     "KMF": 491.561652705,
#     "KPW": 945.520944522,
#     "KRW": 1505.222240174,
#     "KWD": 0.323479065,
#     "KYD": 0.875466073,
#     "KZT": 541.809836336,
#     "LAK": 22745.810448109,
#     "LBP": 94027.039078715,
#     "LKR": 313.6942374,
#     "LRD": 205.43903631,
#     "LSL": 19.32008575,
#     "LTC": 0.009306203,
#     "LTL": 3.452903459,
#     "LVL": 0.702821082,
#     "LYD": 5.151733173,
#     "MAD": 10.484509307,
#     "MDL": 19.337767133,
#     "MGA": 4926.130824139,
#     "MKD": 61.347603448,
#     "MMK": 2205.107010557,
#     "MNT": 3622.680346855,
#     "MOP": 8.39792214,
#     "MRO": 375.050985067,
#     "MUR": 48.625073798,
#     "MVR": 16.233277259,
#     "MWK": 1821.606064073,
#     "MXN": 21.677140849,
#     "MYR": 4.599630243,
#     "MZN": 66.742561807,
#     "NAD": 19.604116408,
#     "NGN": 1628.807601918,
#     "NIO": 38.615153754,
#     "NOK": 11.803534226,
#     "NPR": 145.313981826,
#     "NZD": 1.847878422,
#     "OMR": 0.403542524,
#     "OP": 0.73741505,
#     "PAB": 1.049313514,
#     "PEN": 3.929297239,
#     "PGK": 4.247901454,
#     "PHP": 61.296332683,
#     "PKR": 292.956400061,
#     "PLN": 4.21144693,
#     "PYG": 8337.408762654,
#     "QAR": 3.824608515,
#     "RON": 4.973389489,
#     "RSD": 116.998201782,
#     "RUB": 102.400466527,
#     "RWF": 1456.64171722,
#     "SAR": 3.932343775,
#     "SBD": 8.921098645,
#     "SCR": 15.600407907,
#     "SDG": 631.913938956,
#     "SEK": 11.477754767,
#     "SGD": 1.412031063,
#     "SHP": 0.841806158,
#     "SLL": 23835.610230896,
#     "SOL": 0.004479869,
#     "SOS": 601.108218271,
#     "SRD": 36.631293775,
#     "STD": 24768.234597103,
#     "SVC": 9.192430533,
#     "SYP": 13667.411217959,
#     "SZL": 19.61884493,
#     "THB": 35.451333092,
#     "TJS": 11.470515871,
#     "TMT": 3.676972213,
#     "TND": 3.330528551,
#     "TOP": 2.509996086,
#     "TRY": 37.532530798,
#     "TTD": 7.151481094,
#     "TWD": 34.545559841,
#     "TZS": 2650.615222128,
#     "UAH": 44.18783181,
#     "UGX": 3875.962834397,
#     "USD": 1.05056349,
#     "UYU": 45.478572491,
#     "UZS": 13635.971172183,
#     "VEF": 5944494.833697348,
#     "VND": 26332.235188822,
#     "VUV": 128.172461561,
#     "WST": 2.968905049,
#     "XAF": 655.667221581,
#     "XAG": 0.034770946,
#     "XAU": 0.000383336,
#     "XCD": 2.836521422,
#     "XDR": 0.801149293,
#     "XOF": 655.667219423,
#     "XPD": 0.001088599,
#     "XPF": 119.191099988,
#     "XPT": 0.00111105,
#     "XRP": 0.35018518,
#     "YER": 260.950991921,
#     "ZAR": 19.644940774,
#     "ZMK": 9456.332082011,
#     "ZMW": 29.363988553,
#     "ZWL": 68992.291991699
#   }
# }
#

  ### json data: $json_data

  return unless $json_data->{'success'};

  my $rate = $json_data->{'rates'}{$to};

  return unless $rate + 0;

  # For small rates, request the inverse 
  if ($rate < 0.001) {
    ### Rate is too small, requesting inverse : $rate
    my ($a, $b) = $this->multipliers($ua, $to, $from);
    return ($b, $a);
  }

  return (1.0, $rate);
}

1;

__END__

=head1 NAME

Finance::Quote::CurrencyRates::FXRatesAPI - Obtain currency rates from
FXRatesAPI (https://fxratesapi.com/)

=head1 SYNOPSIS

    use Finance::Quote;
    $q = Finance::Quote->new(currency_rates =>
        {order => ['FXRatesAPI']} );
    $value = $q->currency('18.99 EUR', 'USD');

=head1 DESCRIPTION

This module fetches currency rates from https://fxratesapi.com/ provides
data to Finance::Quote to convert the first argument to the equivalent value 
in the currency indicated by the second argument.

This module is not the default currency conversion module for a Finance::Quote
object. 

=head1 Terms & Conditions

Use of https://fxratesapi.com/ is governed by any terms & conditions of that 
site.

Finance::Quote is released under the GNU General Public License, version 2,
which explicitly carries a "No Warranty" clause.

=cut
