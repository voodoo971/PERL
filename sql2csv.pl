#!/usr/bin/perl -w
use warnings;
use strict;
use 5.010;
use Data::Dumper qw(Dumper);

open(FILE, "<ResultText_201903172138.sql") || die "File not found";
my @lines = <FILE>;
close(FILE);

open(OUT, ">ResultText_201903172138.tmp") || die "File not found";

my $filename = '/var/log/sql2csv.log';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";

print $fh "Processing create tmp file ...\n";

foreach my $line1 (@lines)
{
my @tab = split /VALUES/, $line1;
foreach my $line2 (@tab)
{

   $line2 =~ s/"/ /g;
   $line2 =~ s/\\/\\\\/g;
   $line2 =~ s/'//g;
   $line2 =~ s/NULL/0/g;
   if ($line2 !~ m/INSERT/)
   {

   print OUT $line2;
print $fh "Processing create tmp file ...\n";
 }

}

}




close(OUT);

print $fh "Processing create csv...\n";

system "cat ResultText_201903172138.tmp | tr -d ';' | tr -d ')' | tr -d '(' > ResultText.csv";
my $cmd = 'sed -i "/^[ \t]*$/d" ResultText.csv';
system($cmd);

print "[ Finish ] >>>>>>>>>>>>>> [OK ] \n";

close $fh;
exit;
