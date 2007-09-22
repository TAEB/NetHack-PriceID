# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'NetHack-PriceID';
all_from       'lib/NetHack/PriceID.pm';

requires       '';

build_requires 'Test::More';

auto_install;
WriteAll;

