#!/usr/bin/env perl

my $browser = "firefox";
# my $browser = "brave-browser";
my $config = "$ENV{HOME}/.config/rofi/browser/config.rasi";

# for web dev reasons
# my $ip_addr = `ip addr`;
# my ($lh, $local_ip) = $ip_addr =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/g;

# add your bookmarks here "Title -> url" (" -> " is important)
my @options = (
    "Youtube -> youtube.com/feed/subscriptions",
    "Lichess -> lichess.org",
    "Codeberg -> codeberg.org/anhsirk0",
    "Github -> github.com/anhsirk0",
    "Reddit -> reddit.com",
    "Mail -> mail.yandex.com",
    "Monkeytype -> monkeytype.com",
    "Fm6000 -> github.com/anhsirk0/fetch-master-6000",
    # "Network 3000 -> http://" . $local_ip . ":3000",
    # "Network 8000 -> http://" . $local_ip . ":8000",
    "3000 -> http://localhost:3000",
    "4000 -> http://localhost:4000",
    "4200 -> http://localhost:4200",
    "5173 -> http://localhost:5173",
    "WhatsApp Web -> web.whatsapp.com"
    );

my $joined_options = join "\n", map { (split " -> ", $_)[0] } @options;
my $prompt = "Browser »";
chomp(my $chosen = `echo "$joined_options" | dmenu -p "$prompt" -i`);
exit unless ($chosen);

# match if $chosen is a bookmark
my ($url) = grep { /^$chosen/ } @options;
# shortcuts for search engines (!bang like feature)
my ($key, $query) = $chosen =~ /(^.*?) (.*$)/;

# later used by `notify-send` to send notification
my $message = "$chosen";

# Add your bang searches here
if ($url) {
    s/^.* ->// for $url; # update $url
    # print $url;
} elsif ($key eq "yt") { # Youtube search; for ex: 'yt some video you want'
    $url = "youtube.com/results?search_query=$query";
    $message = qq{Searching youtube for "$query"};
} elsif ($key eq "b") { # Brave search;
    $url = "search.brave.com/search?q=$query";
    $message = qq{Searching brave for "$query"};
} elsif ($key eq "i") { # Yandex reverse image search;
    $url = "yandex.com/images/search?rpt=imageview&url=$query";
    $message = qq{Searching yandex images for "$query"};
} elsif ($key eq "di") { # DDG image search;
    $url = "duckduckgo.com/?q=$query&ia=images&iax=images";
    $message = qq{Searching images on DDG for "$query"};
} elsif ($key eq "u") { # Just a plain url;
    $url = $query;
    $message = qq{Opening "$query"};
} else {# if not a bookmark or a bang search, then search on ddg;
    $url = "duckduckgo.com/?q=$chosen";
    # $url = "ecosia.org/search?q=$chosen";
    $message = qq{Searching duckduckgo for "$chosen"};
}

system("notify-send \'$message\'");
system("$browser \'$url\'");
