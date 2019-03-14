#!/usr/bin/perl

use strict;

# Use at your own risk. I use Perl instead of autotools because I loathe
#    everything about auto-tools
#
#   USAGE:
#
#   Build all:
#       ./make.pl
#       OR
#       perl make.pl
#
#   Clean:
#       perl make.pl clean

use Getopt::Std;
use IPC::Cmd qw[can_run run run_forked];
use Cwd;
use File::Basename;
use File::stat;
use Time::localtime;

my $project = "plasma";
my $project_dir = cwd();
my $parent_dir  = $project_dir;
   $parent_dir  =~ s/\/[^\/]+$//;

our ($opt_o, $opt_v, $opt_V, $opt_s, $opt_t);
getopts('ovVst');

my $verbose=($opt_v or $opt_V);
my $recursive_verbose = "";
   $recursive_verbose = "-V " if $opt_V;

# global defaults
my $default_optimize  = "";
$default_optimize = "-O3" if $opt_o;

my $default_warnings  = "-Wall -Wfatal-errors";
my $default_libraries = "-lm -lncurses -lpthread -lrt -l$project";

# @dep_dirs, @dep_libs

my @default_lib_dirs     = ("${project_dir}/lib");
my @default_include_dirs = ("${project_dir}/src");

my $default_lib_dirs     = "";
my $default_include_dirs = "";

$default_lib_dirs     .= "-L$_ " for(@default_lib_dirs);
$default_include_dirs .= "-I$_ " for(@default_include_dirs);

my $launch_timestamp = time();

makepl_do("touch last_built");

my $arg = shift;
if($arg eq "clean"){
    clean();
}
elsif($arg eq "deps"){
    deps();
}
elsif($arg eq "libs"){
    libs();
}
elsif($arg eq "all"){
    deps();
    make_all();
}
else{
    make_all();
}

makepl_say("Done") if $verbose;

# make everything
sub make_all{

    makepl_say("make_all()") if $verbose;

    libs();
    build();

}


# build deps
sub deps{

    makepl_say("deps()") if $verbose;

}


sub libs{

    makepl_say("libs()") if $verbose;

    makepl_do("mkdir -p lib");

    makepl_cd("src");

    my $optimize  = "$default_optimize";
    my $warnings  = "$default_warnings";
    my $libraries = "$default_libraries";

    my $include_dirs = "$default_include_dirs";
    my $lib_dirs     = "$default_lib_dirs";

    my $build_cmd =   "gcc -c *.c $optimize $warnings $libraries "
                    . "$include_dirs $lib_dirs";

    makepl_do( $build_cmd );

    makepl_do("ar rcs lib$project.a *.o");

    if($opt_s){
        makepl_do("mkdir -p $project_dir/obj");
        makepl_do("mv *.o $project_dir/obj");
    }
    else{
        makepl_do("rm *.o");
    }

    makepl_do("mv *.a $project_dir/lib");

    makepl_cd("$project_dir");

}


# build test
sub build{

    makepl_say("build()") if $verbose;

    makepl_do("mkdir -p bin");

    my $optimize  = "$default_optimize";
    my $warnings  = "$default_warnings";
    my $libraries = "$default_libraries";

    my $include_dirs = "$default_include_dirs";
    my $lib_dirs     = "$default_lib_dirs";

    my $lib_string = get_libs();

    my $build_string =   "gcc test/main.c $lib_string $optimize $warnings "
                       . "$libraries $include_dirs $lib_dirs -o bin/test";

    makepl_do($build_string);

}


# build lib_string
sub get_libs{

    my $lib_string = "";

    foreach my $dir (@default_lib_dirs){

        #my $libs = makepl_do("ls $dir");
        my $libs = `ls $dir/`;
        my @libs = split(/\n/, $libs);

        foreach(@libs){ 
            chomp $_;
            $lib_string .= "$dir/$_ "
        }

    }

    return $lib_string;

}


# clean up build directory
sub clean{

    makepl_say("clean()") if $verbose;
    makepl_do("rm -rf lib");
    makepl_do("rm -rf bin");
    makepl_do("rm -rf obj");
    makepl_do("rm last_built");

}



# run a command
sub makepl_do {

    my $cmd = shift;
    makepl_say("$cmd") if $verbose;

    return if $opt_t; # testing switch set

    my ($success, $error_message, $full_buf, $stdout_buf, $stderr_buf  ) = 
        run( command => $cmd, verbose => 0 );    

    if(!$success){
        makepl_say("Failure detected, stopping...");
        print "$error_message\n";
        print "@{$stderr_buf}\n";
        die;
    }

    return $stdout_buf;

}

# print a message
sub makepl_say {
    print "MAKE.PL($project): $_[0]\n";
}


sub makepl_cd {

    unless( chdir($_[0]) ){
        makepl_say("Error changing to directory: $_[0]");
    }

    my $current_dir = cwd();
    makepl_say("Current directory: $current_dir") if $verbose;

}

