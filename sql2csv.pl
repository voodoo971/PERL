#!/usr/bin/perl -w
use warnings;
use strict;
use 5.010;
use Data::Dumper qw(Dumper);

open(FILE, "<XXX.sql") || die "File not found";
my @lines = <FILE>;
close(FILE);

open(OUT, ">XXX.tmp") || die "File not found";

foreach my $line1 (@lines)
{

my @tab = split /VALUES/, $line1;


foreach my $line2 (@tab)
{
   $line2 =~ s/,/ /g;
$line2 =~ s/'//g;
   if ($line2 !~ m/INSERT/ )
   {

   print OUT $line2;
 }
}
}


close(OUT);


system "cat XXX.tmp | tr -d ';' | tr -d ')' | tr -d '(' > XXX.csv";

exit;
