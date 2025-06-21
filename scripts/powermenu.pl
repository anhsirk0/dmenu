#!/usr/bin/env perl

use warnings;

my @options = (
    # ["test", "echo hi; echo hello"],
    ["lock", "betterlockscreen -l"],
    ["shutdown", "systemctl poweroff"],
    ["reboot", "systemctl reboot"],
    ["suspend", "amixer set Master mute; systemctl suspend"],
    );

chomp(my $uptime = `uptime -p`);
$uptime =~ s/up /Uptime: /g;

my $prompt = "$uptime »";
my $joined_options = join "\n", map { $$_[0] } @options;
chomp(my $chosen = `echo "$joined_options" | dmenu -p "$prompt" -l 15`);
exit unless ($chosen);

for (@options) {
    my $name = $$_[0];
    my $commands = $$_[1];
    next unless ($chosen eq $name);
    for (split ";", $commands) { system($_) };
}
