#!/usr/bin/perl -w
use strict;
use warnings;
use 5.010;
use Digest::MD5;
use Data::Dumper;
my @list_disk = `cli64 disk info | grep 'Pass' | awk '{print \$1}'`;
foreach my $disk_s  (@list_disk) {
my $cmd = "cli64 disk smart drv=".$disk_s."";
my @result = `$cmd`;
my $filename = '/var/log/smartd.log';
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
print $fh $result[-1];
print $result[-1] ."Disque dur => ".$disk_s;
close $fh;
}
