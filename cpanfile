requires 'Config::Tiny', '0';
requires 'File::Share', '0';
requires 'Path::Tiny', '0';
requires 'XML::LibXML', '0';

on test => sub {
    requires 'Test2::V0', '0';
    requires 'Test::More', '0.96';
    requires 'Test::Script', '0';
};