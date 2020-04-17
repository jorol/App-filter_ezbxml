# NAME

App::filter\_ezbxml - filter EZBXML data by journal package URL

# SYNOPSIS

    # in Perl code
    use App::filter_ezbxml;
    my $app = App::filter_ezbxml->new();
    $app->filter($dir)

    # on the command line
    $ filter_ezbxml <DIR>

# DESCRIPTION

App::filter\_ezbxml is an app to filter EZBXML records by their README URLs. 
The URLs to filter a read from an INI file. The filtered files are written 
to the same directory, _\_filtered_ is appended to filenames. The IDs of 
filtered records are written to _update\_dump2020{week}.log_.

# AUTHOR

Johann Rolschewski <jorol@cpan.org>

# COPYRIGHT

Copyright 2020- Johann Rolschewski

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
