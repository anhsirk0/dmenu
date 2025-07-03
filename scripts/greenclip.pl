#!/usr/bin/env perl

use warnings;

my $prompt = "Greenclip »";
chomp(my $chosen = `greenclip print | dmenu -p "$prompt" -l 15 -i`);
unless ($chosen) { exit };

system("printf '%s' '$chosen' | xclip -selection clipboard");
