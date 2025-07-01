#!/usr/bin/env perl

use warnings;

my $EMOJI_FILE = "all-emojis.txt";
open my $FH, '<', $EMOJI_FILE or die "Can't open file: $!";
my $all_emojis = do { local $/; <$FH> };
close $FH;

my $prompt = "Emoji »";
chomp(my $chosen = `echo "$all_emojis" | dmenu -p "$prompt" -l 15 -i`);
unless ($chosen) { exit };

chomp(my $emoji = (split ",", $chosen)[0]);
system("echo -n $emoji | xclip -selection clipboard");
