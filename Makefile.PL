# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'NetHack-PriceID';
all_from       'lib/NetHack/PriceID.pm';

requires       'Exporter';
requires       'parent';
requires       'Getopt::Euclid';

install_script 'bin/priceid';

auto_install;
WriteAll;

