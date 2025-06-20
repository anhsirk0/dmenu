#!/usr/bin/perl -w

my $db = "$ENV{HOME}/.local/share/lollypop/lollypop.db";
my $rofi_config = "$ENV{HOME}/.config/rofi/lollypop/config.rasi";
my $query = q{select tracks.id, tracks.name, artists.name from tracks
              join track_artists on track_artists.track_id = tracks.id
              join artists on track_artists.artist_id = artists.id
              order by popularity desc;};

# get current playing song and artist
sub get_song_and_artist {
    my ($song, $artist) = grep /title|artist/, split "\n", `pactl list`;
    s/.*?\"//, s/\(.*?\)|\"//g, s/\s+$//, chomp for $song, $artist;
    $artist =~ s/ & /, /;
    return ($song, $artist)
}

sub main {
    my @all = split "\n", `echo "$query" | sqlite3 $db`;

    # collect songs in @songs (no duplicates)
    my %seen = ();
    my @songs = grep { ! $seen{substr $_, 0, 4} ++ } @all;

    my @names = ();
    my %ids = (); # { "name" => id }

    # refactoring song names and populating @names and %ids
    foreach my $song (@songs) {
        # s/Ft.*\|/|/g, s/\(.*?\)//g, s/\|/+/, s/\|/ -  / for $song;
        s/\|/+/, s/\|/ -  / for $song;
        my @temp = split('\+', $song);
        $ids{$temp[1]} = $temp[0];
        push(@names, $temp[1]);
    }

    # update placeholder
    # my ($song, $artist) = get_song_and_artist();

    my $joined_names = join "\n", @names;
    my $prompt = "Lollypop »";
    chomp(my $var = `echo "$joined_names" | dmenu -p "$prompt" -l 30`);

    exit unless ($var);
    my ($song, $artist) = split "-", $var;
    system(qq{notify-send "=> $song" "$artist"; lollypop -m $ids{$var}});
}

main()
