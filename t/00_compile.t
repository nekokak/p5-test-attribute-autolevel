use strict;
use Test::More;

BEGIN {
    if ($] < 5.012001) { # just in case..
        plan(skip_all => "requires perl 5.012001 or greater");
    }
    use_ok 'Test::Attribute::AutoLevel';
}

done_testing;
