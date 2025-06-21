#!/usr/bin/env perl

use warnings;

my @desktop_list = split "\n", `wmctrl -d`;
my %desktops = ("-1" => "-"); # WORKAROUND: sticky windows (-1)
my $active_desktop_idx = "0";

for (@desktop_list) {
    my ($index, $active, $name) = $_ =~ m/^(\d+)\s+(.) .* (.*?)$/;
    $desktops{$index} = $name;
    $active_desktop_idx = $index if ($active eq "*");
}

my @window_list = split "\n", `wmctrl -l`;
my $windows = "";

for my $i (1 .. scalar @window_list) {
    my ($idx, $h, $name) = $window_list[$i -1] =~ m/^.*?\s+(\d+) (.*?) (.*?)$/;
    my $desktop_name = $desktops{$idx};
    my $active = $active_desktop_idx eq $idx ? "*" : "-";
    $windows .= "$i $active [$desktop_name] $name\n";
}
chomp $windows;

my $prompt = "Windows »";
chomp(my $chosen = `echo "$windows" | dmenu -p "$prompt" -l 15`);
exit unless ($chosen);

my ($num) = $chosen =~ m/^(\d+).*$/;
my ($window_id) = $window_list[$num -1] =~ m/^(.*?)\s+.*$/;

exit system("wmctrl -i -a $window_id");
