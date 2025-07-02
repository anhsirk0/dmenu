#!/usr/bin/env perl

use warnings;
my $theme_script = "~/.config/myshell/scripts/theme";

my $prompt = "Theme »";
chomp(my $chosen = `$theme_script --list | dmenu -p "$prompt" -l 15 -i`);
unless ($chosen) { exit };

system("$theme_script $chosen");
