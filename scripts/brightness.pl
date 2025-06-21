#!/usr/bin/env perl

use warnings;

my $current_brightness = `xbacklight -get`;
chomp for ($current_brightness);

my @options = map { "Brightness " . $_ * 10 . "%" } 1 .. 10;
unshift(@options, ("Brightness 1%", "Inc brightness 10%", "Dec brightness 10%"));
push(@options, "Blugon"); # Blue light filter

my $joined_options = join "\n", @options;
my $prompt = "Brightness ($current_brightness) »";
chomp(my $chosen = `echo "$joined_options" | dmenu -p "$prompt" -l 15`);

exit unless ($chosen);

my ($num) = $chosen =~ /(\d+)/; # only digits
my $new_brightness;

if ($chosen =~ /Blugon/) {
    exit system("blugon && notify-send Blugon");
} elsif ($chosen =~ /^a|inc/i) {
    $new_brightness = $current_brightness + $num;
} elsif ($chosen =~ /^d|dec/i) {
    $new_brightness = $current_brightness - $num;
} else {
    $new_brightness = $num;
}

system("xbacklight -set $new_brightness && notify-send Brightness $new_brightness");

