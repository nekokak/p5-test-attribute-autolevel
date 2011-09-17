package Test::Function;
use strict;
use warnings;
our $VERSION = '0.01';

sub import {
    my $caller = caller(0);

    {
        my $_cache = +{};
        my $cache_func = sub {
            my ($fake_code, $org_code) = @_;
            $_cache->{$fake_code} = $org_code if $org_code;
            $_cache->{$fake_code};
        };

        no strict 'refs';
        *{"${caller}::MODIFY_CODE_ATTRIBUTES"}  = \&MODIFY_CODE_ATTRIBUTES;
        *{"${caller}::_cache"} = $cache_func;
    }
}

sub _fake {
    my ($pkg, $code, $funcname) = @_;
    my $cache = \&{"${pkg}::_cache"};

    my $fake = sub {
        my $fake_code = \&{"${pkg}::${funcname}"};
        local $Test::Builder::Level = $Test::Builder::Level + 2;
        $cache->($fake_code)->(@_);
    };
    $cache->($fake => $code);

    no strict 'refs';
   *{"${pkg}::${funcname}"} = $fake;
}

sub MODIFY_CODE_ATTRIBUTES {
    my ($pkg, $code, @attrs) = @_;
    _fake($pkg, $code, $attrs[0]);
    return;
}

1;

__END__

=head1 NAME

Test::Function -

=head1 SYNOPSIS

  use Test::Function;

=head1 DESCRIPTION

Test::Function is

=head1 AUTHOR

Atsushi Kobayashi E<lt>nekokak _at_ gmail _dot_ comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
