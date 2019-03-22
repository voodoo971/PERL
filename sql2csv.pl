#!/usr/bin/perl -w
use warnings;
use strict;
use 5.010;
use Data::Dumper qw(Dumper);
use Cwd qw(cwd);


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
  my $cmd = "sed -i \"\/\^\[ \\t\]\*\$\/\d\" $ext_csv_new";
    system ($cmd);
  print "[ Finish ] création fichier csv $ext_csv_new [OK ]\n";
  close $fh;

}

my $path = cwd;


my @file_path = `ls $path | grep \.sql`;

foreach my $list_file_sql (@file_path)
{

generate_csv($list_file_sql );

}

exit;
