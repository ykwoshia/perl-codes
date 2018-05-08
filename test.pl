#!/usr/bin/env perl
use strict;
use warnings;
BEGIN{unshift @INC, '.'}
use Test::More tests => 19;
use Test::Files;
use_ok('Global');

my $some_file = "faf";

my $comment_oneline_1 = '12{ this is a comment }345';
my $comment_oneline_2 = '67(* this is a comment *)8910';
my $comment_oneline_3 = '{ this is a comment }34512(* this is a comment *)345';

open my $fh, '<', \$comment_oneline_1;
my ($line_number, $lines, $str_comments) = Global::RemoveCommentReadlines($fh);
is($line_number, 1);
is($lines, "12345");
is($str_comments, " this is a comment ");
close $fh;

open $fh, '<', \$comment_oneline_2;
($line_number, $lines, $str_comments) = Global::RemoveCommentReadlines($fh);
is($line_number, 1);
is($lines, "678910");
is($str_comments, " this is a comment ");
close $fh;

open $fh, '<', \$comment_oneline_3;
($line_number, $lines, $str_comments) = Global::RemoveCommentReadlines($fh);
is($line_number, 1);
is($lines, "34512345");
is($str_comments, " this is a comment  //  this is a comment ");
close $fh;


my $comment_multiline1 = 
'12{ this is (*a comment }345 {
    here xxx
}388*)
(*comment1*) PinSet(wrw, 123); {comment2}';

open $fh, '<', \$comment_multiline1;
($line_number, $lines, $str_comments) = Global::RemoveCommentReadlines($fh);
is($line_number, 3);
is($lines, "12");
is($str_comments, " this is {a comment }345 {    here xxx}388");

($line_number, $lines, $str_comments) = Global::RemoveCommentReadlines($fh);
is($line_number, 4);
is($lines, " PinSet(wrw, 123); ");
is($str_comments, "comment1 // comment2");

($line_number, $lines, $str_comments) = Global::RemoveCommentReadlines($fh);
is($line_number, 0);
is($lines, undef); ## here is line number
is($str_comments, undef);
close $fh;

