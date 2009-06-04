# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'NetHack-PriceID';
all_from       'lib/NetHack/PriceID.pm';

requires       'Getopt::Euclid';

install_script 'bin/priceid';

githubmeta;
auto_install;
WriteAll;

