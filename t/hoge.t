use strict;
use warnings;
use Test::More;
use Test::Function;

sub test_moge : TEST {
    ok 0;
}

sub test_foo : Test {
    ok 0;
}

sub test_nest2 : Test {
    ok 0;
}

sub test_nest1 : Test {
    ok 0;
    test_nest2();
}

sub test_nest3 : Test {
    ok 0;
    test_nest2();
}

sub test_nest4 : Test {
    ok 0;
    test_nest1();
}

test_moge();
test_foo();
test_nest1();
test_nest3();
test_nest4();

done_testing;
