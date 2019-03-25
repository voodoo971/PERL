#!/usr/bin/perl -w
use warnings;
use strict;
use 5.010;
use Data::Dumper qw(Dumper);
use Cwd qw(cwd);
use File::Map qw/map_file advise/;
use Sys::Mmap;
require File::Temp;
use File::Temp ();
use File::Temp qw/ :seekable /;




sub generate_csv {
  my ($file_sql) = @_;
(my $without_extension = $file_sql) =~ s/.sql//g;
(my $ext_tmp = $file_sql) =~ s/.sql/.tmp/g;
(my $ext_csv = $file_sql) =~ s/.sql/.csv/g;
(my $ext_csv_new = $ext_csv) =~ s/_(\d+)//g;


  open(FILE, "<$file_sql") || die "File not found";
  my @lines = <FILE>;
  close(FILE);
  open(OUT, ">$ext_tmp") || die "File not found";
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
  print $fh "Processing create tmp file from file : $file_sql\n";
   }
  }
  }
  close(OUT);
  print $fh "Processing create csv from file : $ext_csv \n";
chomp($ext_tmp);
print "[ Processing ] création en cours fichier csv [ $ext_csv ]\n";
my $s = "cat $ext_tmp | tr -d ';' | tr -d ')' | tr -d '(' > $ext_csv_new";

  system ($s);
  my $cmd = "sed -i \"\/\^\[ \\t\]\*\$\/\\d\" $ext_csv_new";
    system ($cmd);
  print "[ Finish ] création fichier csv $ext_csv_new [OK ]\n";
  close $fh;

}
#################################

sub split_sql {

system("rm -rf *.");
my ($file_sql) = @_;
chomp $file_sql;
my $filecount=0;

(my $without_extension = $file_sql) =~ s/.sql//g;

 my $new_filename = $without_extension."_".$filecount.".tmp";


  open(OUT, ">$new_filename") || die "File not found";

my $size = -s $file_sql;
#if ($size > 10000000000){
print "Fichier SQL superieur à 10Go on le split \n";


map_file my($map), $file_sql;
	advise $map, 'sequential';
  #print Dumper($map);
my $delimiter = quotemeta ');';
 my @tab = split /" "/, $map;

my $count = 0 ;
foreach my $line (@tab)
{
#rint $count++, ": $line\n"  ;
print Dumper $line;
#say $new_filename;
   print OUT $line;

}
$filecount++;
 close(OUT);
}



######## START SCRIPT

## Purge memory Linux
system("echo 3 > /proc/sys/vm/drop_caches");

my $path = cwd;
my @file_path = `ls $path | grep \.sql`;

foreach my $list_file_sql (@file_path)
{

split_sql($list_file_sql);
#generate_csv($list_file_sql );

}













#generate_csv($list_file_sql );

exit;

### mktemp File
#my $fh = File::Temp->new();
#my $fname = $fh->filename;
#$fh = File::Temp->new(TEMPLATE => my $template);
#$fname = $fh->filename;
#my $tmp = File::Temp->new( UNLINK => 0, SUFFIX => '.dat' ,DIR => '/nvme/glims_dump/tmp/');
#print $tmp $map;
#
