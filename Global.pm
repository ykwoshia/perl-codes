package Global;
use strict;
use warnings;


my $content;
$content = qr/(?>[^{}]+|\{(??{$content})\})*/s;

# open my $FH, "<", "./device.p" or die;

# RemoveCommentReadlines($FH);

sub RemoveCommentReadlines
{
    my $FH = shift;
    my $lines = "";
    my $line_number;
    my @comments;

    while(my $line = <$FH>)
    {
        chomp($line);
        $line =~ s/\(\*/\{/g;
        $line =~ s/\*\)/\}/g;

        $lines .= $line;
        $line_number = $.;

        if($lines =~ /^[^{]*\{$content\}/)
        {
            while($lines =~ /^[^{]*\{($content)\}/)
            {
                push @comments, $1;
                $lines =~ s/^([^{]*)\{$content\}/$1/;
            }
        }
        if($lines =~ /\{/)
        {
            next;
        }
        else
        {
            my $str_comments = join ' // ', @comments;
            return ($line_number, $lines, $str_comments);
        }
        
        print $line;
    }

    return (0, undef, undef);

}
