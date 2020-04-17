use strict;
use warnings;
use Test::More;
use App::filter_ezbxml;

my $app = App::filter_ezbxml->new();
isa_ok $app, 'App::filter_ezbxml';
can_ok $app, qw(filter_files _load_filter);

done_testing;
