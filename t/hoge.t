use strict;
use warnings;
use Test::More;
use Test::Function;

sub test_foo : test_foo {
    ok 0;
}

sub test_nest2 : test_nest2 {
    ok 0;
}

sub test_nest1 : test_nest1 {
    ok 0;
    test_nest2();
}

test_foo();
test_nest1();

done_testing;
