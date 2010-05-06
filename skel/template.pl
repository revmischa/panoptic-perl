#!/usr/bin/perl
use warnings; 
use strict;
use File::Find;

die "Usage: perl template.pl directory projectname\n" unless @ARGV == 2;
my $target = shift;
my $project_name = shift;
die "$target is not a valid directory\n" unless (-d "$target");

sub traverse {
    my ($base, $project_name) = @_;
    my @dirs = get_dirs($base, $project_name);
    return unless @dirs;
    for my $branch (@dirs) {
        traverse($branch, $project_name);
    }
}
sub get_dirs {
    my ($dir, $project_name) = @_;
    my @dirs;
    opendir FH, "$dir" if -e $dir;
    chdir($dir);
    my @files = readdir(FH);
    for (@files) {
        my $dirname = $_;
        if (-d $_ and $_ ne "." and $_ ne "..") {
            if ($dirname =~ /__PLACEHOLDER__/) {
                $dirname =~ s/__PLACEHOLDER__/$project_name/;
                rename("$_", "$dirname");
            }
            push @dirs, $dirname;
        }
    }
    return @dirs;
}



my %options = (
    wanted => sub {
        my $file = $_;
        my $file_copy = $file;
        my @file;
        if (-f $file) {
            open FH, "$file";
            while (my $line = <FH>) {
                $line =~ s/__PLACEHOLDER__/$project_name/;
                push @file, $line;
            }
            close FH;
            open FH2, ">$file";
            foreach (@file) {
                print FH2 "$_";
            }
            close FH2;
            if ($file =~/__PLACEHOLDER__/) {
                $file =~ s/__PLACEHOLDER__/$project_name/;
                rename ("$file_copy", "$file");
            }
            print "processed $file\n";
        }
    }
    );
find(\%options, $target);
traverse($target, $project_name);
