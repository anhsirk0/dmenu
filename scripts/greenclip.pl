#!/usr/bin/env perl

use warnings;

my $prompt = "Greenclip »";
chomp(my $chosen = `greenclip print | dmenu -p "$prompt" -l 15 -i`);
unless ($chosen) { exit };

$chosen =~ s/ /\n/g;
system("printf '%s' '$chosen' | xclip -selection clipboard");
