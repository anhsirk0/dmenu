#!/usr/bin/env perl

use warnings;

my @desktop_list = split "\n", `wmctrl -d`;
my %desktops = ("-1" => "-"); # WORKAROUND: sticky windows (-1)

for (@desktop_list) {
    my ($index, $active, $name) = $_ =~ m/^(\d+)\s+(.) .* (.*?)$/;
    $desktops{$index} = $name;
}

my @window_list = split "\n", `wmctrl -l`;
my $windows = "";
my $count = 0;

for my $i (1 .. scalar @window_list) {
    my ($idx, $h, $name) = $window_list[$i -1] =~ m/^.*?\s+(\d+) (.*?) (.*?)$/;
    if ($name =~ m/^\[\d+%\]/) {
        $count++;
        $windows .= "$count) $name\n";        
    }
}
chomp $windows;

my $prompt = "XDM »";
chomp(my $chosen = `echo "$windows" | dmenu -p "$prompt" -l 15 -i`);
exit unless ($chosen);

my ($num) = $chosen =~ m/^(\d+).*$/;
my ($window_id) = $window_list[$num -1] =~ m/^(.*?)\s+.*$/;

exit system("wmctrl -i -a $window_id");
