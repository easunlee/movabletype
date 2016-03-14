#!/usr/bin/perl
# $Id: 35-tags.t 3531 2009-03-12 09:11:52Z fumiakiy $
use strict;
use warnings;
use IPC::Open2;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

$| = 1;

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT::Test qw(:db :data);
use Test::More;
use JSON -support_by_pp;
use MT;
use MT::Util qw(ts2epoch epoch2ts);
use MT::Template::Context;
use MT::Builder;

require POSIX;

my $mt = MT->new();

# Set config directives.
$mt->config->AllowComments( 1, 1 );
$mt->config->StaticFilePath( './mt-static', 1 );
$mt->config->CommenterRegistration( { Allow => 1 }, 1 );
$mt->config->save_config;

# Clear cache
my $request = MT::Request->instance;
$request->{__stash} = {};

local $/ = undef;
open F, "<t/35-tags.dat";
my $test_json = <F>;
close F;

$test_json =~ s/^ *#.*$//mg;
$test_json =~ s/# *\d+ *(?:TBD.*)? *$//mg;

my $json = new JSON;
$json->loose(1); # allows newlines inside strings
my $test_suite = $json->decode($test_json);

# Ok. We are now ready to test!
plan tests => (scalar(@$test_suite) * 2) + 3;

my $blog_name_tmpl = MT::Template->load({name => "blog-name", blog_id => 1});
ok($blog_name_tmpl, "'blog-name' template found");

my $ctx = MT::Template::Context->new;
my $blog = MT::Blog->load(1);
ok($blog, "Test blog loaded");
$ctx->stash('blog', $blog);
$ctx->stash('blog_id', $blog->id);
$ctx->stash('builder', MT::Builder->new);

my $entry  = MT::Entry->load( 1 );
ok($entry, "Test entry loaded");

# entry we want to capture is dated: 19780131074500
my $tsdiff = time - ts2epoch($blog, '19780131074500');
my $daysdiff = int($tsdiff / (60 * 60 * 24));
my %const = (
    CFG_FILE => MT->instance->{cfg_file},
    VERSION_ID => MT->instance->version_id,
    CURRENT_WORKING_DIRECTORY => MT->instance->server_path,
    STATIC_CONSTANT => '1',
    DYNAMIC_CONSTANT => '',
    DAYS_CONSTANT1 => $daysdiff + 2,
    DAYS_CONSTANT2 => $daysdiff - 1,
    CURRENT_YEAR => POSIX::strftime("%Y", localtime),
    CURRENT_MONTH => POSIX::strftime("%m", localtime),
    STATIC_FILE_PATH => MT->instance->static_file_path . '/',
    THREE_DAYS_AGO => epoch2ts($blog, time() - int(3.5 * 86400)),
);

$test_json =~ s/\Q$_\E/$const{$_}/g for keys %const;
$test_suite = $json->decode($test_json);

$ctx->{current_timestamp} = '20040816135142';

my $num = 1;
foreach my $test_item (@$test_suite) {
    unless ($test_item->{r}) {
        pass("perl test skip " . $num++);
        next;
    }
    local $ctx->{__stash}{entry} = $entry if $test_item->{t} =~ m/<MTEntry/;
    $ctx->{__stash}{entry} = undef if $test_item->{t} =~ m/MTComments|MTPings/;
    $ctx->{__stash}{entries} = undef if $test_item->{t} =~ m/MTEntries|MTPages/;
    $ctx->stash('comment', undef);
    $request->{__stash} = {};
    my $result = build($ctx, $test_item->{t});
    is($result, $test_item->{e}, "perl test " . $num++);
}

php_tests($test_suite);

sub build {
    my($ctx, $markup) = @_;
    my $b = $ctx->stash('builder');
    my $tokens = $b->compile($ctx, $markup);
    print('# -- error compiling: ' . $b->errstr), return undef
        unless defined $tokens;
    my $res = $b->build($ctx, $tokens);
    print '# -- error building: ' . ($b->errstr ? $b->errstr : '') . "\n"
        unless defined $res;
    return $res;
}

sub php_tests {
    my ($test_suite) = @_;
    my $test_script = <<'PHP';
<?php
include_once("php/mt.php");
include_once("php/lib/MTUtil.php");
require "t/lib/JSON.php";

$cfg_file = '<CFG_FILE>';

$const = array(
    'CFG_FILE' => $cfg_file,
    'VERSION_ID' => VERSION_ID,
    'CURRENT_WORKING_DIRECTORY' => '',
    'STATIC_CONSTANT' => '',
    'DYNAMIC_CONSTANT' => '1',
    'DAYS_CONSTANT1' => '<DAYS_CONSTANT1>',
    'DAYS_CONSTANT2' => '<DAYS_CONSTANT2>',
    'CURRENT_YEAR' => strftime("%Y"),
    'CURRENT_MONTH' => strftime("%m"),
    'STATIC_FILE_PATH' => '<STATIC_FILE_PATH>',
    'THREE_DAYS_AGO' => '<THREE_DAYS_AGO>',
);

$output_results = 0;

$mt = MT::get_instance(1, $cfg_file);
$ctx =& $mt->context();

$path = $mt->config('mtdir');
if (substr($path, strlen($path) - 1, 1) == '/')
    $path = substr($path, 1, strlen($path)-1);
if (substr($path, strlen($path) - 2, 2) == '/t')
    $path = substr($path, 0, strlen($path) - 2);
$const['CURRENT_WORKING_DIRECTORY'] = $path;

$db = $mt->db();

$db->db()->Execute( "SET time_zone = '-7:00'" );

$ctx->stash('blog_id', 1);
$blog = $db->fetch_blog(1);
$ctx->stash('blog', $blog);
$ctx->stash('current_timestamp', '20040816135142');
$mt->init_plugins();
$entry = $db->fetch_entry(1);

$suite = load_tests();

set_error_handler('error_handler');

run($ctx, $suite);

function run(&$ctx, $suite) {
    $test_num = 0;
    global $entry;
    global $mt;
    global $tmpl;
    $base_stash = $ctx->__stash;
    foreach ($suite as $test_item) {
        $ctx->__stash = $base_stash;
        $mt->db()->savedqueries = array();
        if ( preg_match('/MT(Entry|Link)/', $test_item->t) 
          && !preg_match('/MT(Comments|Pings)/', $test_item->t) )
        {
            $ctx->stash('entry', $entry);
        }
        else {
            $ctx->__stash['entry'] = null;
        }
        if ( preg_match('/MTEntries|MTPages/', $test_item->t) ) {
            $ctx->__stash['entries'] = null;
            $ctx->__stash['author'] = null;
            $ctx->__stash['category'] = null;
        }
        if ( preg_match('/MTCategoryArchiveLink/', $test_item->t) ) {
            $ctx->stash('current_archive_type', 'Category');
        } else {
            $ctx->stash('current_archive_type', '');
        }
        $test_num++;
        if ($test_item->r == 1) {
            $tmpl = $test_item->t;
            $result = build($ctx, $test_item->t);
            ok($result, $test_item->e, $test_num);
        } else {
            echo "ok - php test $test_num\n";
        }
    }
}

function load_tests() {
    $suite = cleanup(file_get_contents('t/35-tags.dat'));
    $json = new JSON();
    global $const;
    foreach ($const as $c => $r) {
        $suite = preg_replace('/' . $c . '/', $r, $suite);
    }
    $suite = $json->decode($suite);
    return $suite;
}

function cleanup($tmpl) {
    # Translating perl array/hash structures to PHP...
    # This is not a general solution... it's custom built for our input.
    $tmpl = preg_replace('/^ *#.*$/m', '', $tmpl);
    $tmpl = preg_replace('/# *\d+ *(?:TBD.*)? *$/m', '', $tmpl);
    return $tmpl;
}

function build(&$ctx, $tmpl) {
    global $error_messages;
    $error_messages = array();
    $_var_compiled = $ctx->fetch("eval:$tmpl");
    if($_var_compiled) {
        ob_start();
        eval('?>' . $_var_compiled);
        $_contents = ob_get_contents();
        ob_end_clean();
        return join('', $error_messages) . $_contents;
    } else {
        return $ctx->error("Error compiling template module '$module'");
    }
}

function ok($str, $that, $test_num) {
    global $mt;
    global $tmpl;
    $str = trim($str);
    $that = trim($that);
    if ($str === $that) {
        echo "ok - php test $test_num\n";
        return true;
    } else {
        echo "not ok - php test $test_num\n".
             "#     expected: $that\n".
             "#          got: $str\n";
        return false;
    }
}

function error_handler($errno, $errstr, $errfile, $errline) {
    global $error_messages;
    if ($errno & (E_ALL ^ E_NOTICE)) {
        array_push($error_messages, $errstr . "\n");
    }
}

?>
PHP

    $test_script =~ s/<\Q$_\E>/$const{$_}/g for keys %const;

    # now run the test suite through PHP!
    my $pid = open2(\*IN, \*OUT, "php");
    print OUT $test_script;
    close OUT;
    select IN;
    $| = 1;
    select STDOUT;

    my @lines;
    my $num = 1;

    my $test = sub {
        while (@lines) {
            my $result = shift @lines;
            if ($result =~ m/^ok/) {
                pass($result);
            } elsif ($result =~ m/^not ok/) {
                fail($result);
            } elsif ($result =~ m/^#/) {
                print STDERR $result . "\n";
            } else {
                print $result . "\n";
            }
        }
    };

    my $output = '';
    while (<IN>) {
        $output .= $_;
        if ($output =~ m/\n/) {
            my @new_lines = split /\n/, $output;
            $output = pop @new_lines;
            push @lines, @new_lines;
        }
        $test->() if @lines;
    }
    push @lines, $output if $output ne '';
    close IN;
    $test->() if @lines;
}
