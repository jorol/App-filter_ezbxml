package App::filter_ezbxml;

use strict;
use warnings;

our $VERSION = '0.02';

use Config::Tiny;
use File::Share ':all';
use Path::Tiny;
use XML::LibXML;

sub new {
    my ($class) = @_;
    my $self = {};
    bless $self, $class;
    $self->{filter} = $self->_load_filter();
    return $self;
}

sub filter_files {
    my ( $self, $dir ) = @_;

    # get XML files form directory
    my @files = path($dir)->children(qr/\.xml$/);
    die "no XML files found in directory \"$dir\"" unless @files;

    # create LOG file
    $files[0] =~ m/(update_dump\d+)/;
    my $log_file = $1 // 'log';
    $log_file = $dir . '/' . $log_file . '.log';
    open( my $fh_log, ">:encoding(UTF-8)", "$log_file" )
        || die "Can't open $log_file: $!";
    print "created LOG file $log_file\n";

    # filter each file
    foreach my $file (@files) {

        # load XML file
        my $doc
            = XML::LibXML->new->load_xml( location => $file, no_blanks => 1 );

        # find nodes <license_set>
        for my $node ( $doc->findnodes('//license_set') ) {

            # get <available>
            my $available = $node->findvalue('.//available');
            next unless $available;
            $available =~ s/^\s+|\s+$//g;

            # get EZB item ID
            my $ezbid = $node->findvalue('./license_entry_id');

            # get ISIL of library
            my $isil = $node->findvalue('./isil');

            # get action (delete, insert, update)
            my $action = $node->findvalue('./action');

            # filter nodes by text of <available>
            if ( $available =~ $self->{filter} && $action =~ 'delete|insert|update' ) {

                # create LOG entry and delete node
                print $fh_log "$ezbid\t$isil\t$file\n";
                $node->parentNode->removeChild($node);
            }
        }

        # write filtered XML to file
        my $filename = $dir . '/' . $file->basename('.xml') . '_filtered.xml';
        $doc->toFile($filename,1);
        print "created new file $filename\n";
    }

    close $fh_log;
}

sub _load_filter {
    my $self    = shift;
    my $file    = dist_file( 'App-filter_ezbxml', 'filter_ezbxml.ini' );
    my $config  = Config::Tiny->read( $file, 'utf8' );
    my $filters = $config->{filter};
    my $values  = join '|', values %{$filters};
    my $regex   = qr{($values)};
    return $regex;
}

1;

__END__

=encoding utf-8

=head1 NAME

App::filter_ezbxml - filter EZBXML data by journal package URL

=head1 SYNOPSIS
    
  # in Perl code
  use App::filter_ezbxml;
  my $app = App::filter_ezbxml->new();
  $app->filter($dir)

  # on the command line
  $ filter_ezbxml <DIR>

=head1 DESCRIPTION

App::filter_ezbxml is an app to filter EZBXML records by their README URLs. 
The URLs to filter a read from an INI file. The filtered files are written 
to the same directory, I<_filtered> is appended to filenames. The IDs of 
filtered records are written to I<update_dump2020{week}.log>.

=head1 AUTHOR

Johann Rolschewski E<lt>jorol@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2020- Johann Rolschewski

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
