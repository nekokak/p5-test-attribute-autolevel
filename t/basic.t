use strict;
use warnings;
use Test::More;
use IPC::Open3;
use IO::Select;

BEGIN {
    if ($] < 5.012001) { # just in case..
        plan(skip_all => "requires perl 5.012001 or greater");
    }
}

my $pid = open3(\*CHILD_IN, \*CHILD_OUT, \*CHILD_ERR, 'prove -lvc ./t/internal_test')
 or die 'internal_test execute failed....';

my ($stdin, $stdout, $stderr) = (\*CHILD_IN, \*CHILD_OUT, \*CHILD_ERR);

my $reader = IO::Select->new;
$reader->add($stderr);

my @tests;
while (my @ready = $reader->can_read()) {
    for my $fh (@ready) {
        my $line = <$fh>;
        if (not defined $line)  {
            close $fh;
        } else {
            chomp $line;
            next unless $line;
            next unless $line =~ /at .\/t\/internal_test line/;
            push @tests, $line;
        }
    }
}

is_deeply \@tests, [
    '#   at ./t/internal_test line 19.',
    '#   at ./t/internal_test line 20.',
    '#   at ./t/internal_test line 20.',
];

done_testing;

