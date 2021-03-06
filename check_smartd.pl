#!/usr/bin/perl -w
#############################"
#
#  INSTALL
#
#  cpan install Monitoring::Plugin
use strict;
use warnings;
use 5.010;
use Data::Dumper;
use POSIX;
use Monitoring::Plugin;
my $VERSION = '1.0';
 my $LICENCE
  = "Ce plugin est distribué en interne à CCIF";
my $plugin = Monitoring::Plugin->new(
  shortname => 'CHECK S.M.A.R.T',
  version => $VERSION,
  license => $LICENCE,
);
$| = 1;
my $filename = '/var/log/smartd.log';
open my $fh, '-|', tail => -50, $filename
  or die "Could not open file '$filename' $!";
while (my $row = <$fh>) {
  chomp $row;

if ($row =~ m/Error/)
{

$plugin->add_message(CRITICAL, "$row\n");
}
}

$plugin->add_message(OK, "AUCUNE ERREUR S.M.A.R.T\n");
my ($code, $message) = $plugin->check_messages();
$plugin->nagios_exit($code, $message);
