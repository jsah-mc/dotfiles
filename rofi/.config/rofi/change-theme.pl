#! /usr/bin/env perl
use File::Find;

my $XDG = defined $ENV{XDG_CONFIG_HOME} ? $ENV{XDG_CONFIG_HOME} : "$ENV{HOME}/.config";
my $dir = "$XDG/rofi/";
my $colors_dir = "$XDG/rofi/colors";
my $theme;
my @all_config_files;

sub wanted {
    my $name = $File::Find::name;
    my $file = (split "/", $name)[-1];
    if ($file =~ /^\./) { return } # ignore hidden files/dirs

    if (-f && $_ =~ /config.rasi$/) {
        push(@all_config_files, $name);
    }
}

sub update_file {
    my ($config) = @_;
    my $config_content = "";

    # read config file
    open(FH, '<' . $config) or die "Unable to open\n";
    while(<FH>) {
        if ($_ =~ /import.*colors/) {
            $config_content .= qq{\@import\t "colors/$theme.rasi"\n};
            next;
        }
        $config_content .= $_;
    }
    close(FH);

    # write config file
    open(FH, '>' . $config) or die "Unable to open\n";
    print FH $config_content;
    close(FH);
}

sub main {
    # build list of theme files (only .rasi)
    opendir my $dh, $colors_dir or die "Cannot open $colors_dir: $!\n";
    my @all_themes = grep { /\.rasi$/ && -f "$colors_dir/\$_" } readdir $dh;
    closedir $dh;
    @all_themes = sort @all_themes;

    if (scalar @ARGV > 0) {
        my $arg = $ARGV[0];
        # prefer exact match (with or without extension)
        ($theme) = grep { $_ eq $arg || $_ eq "$arg.rasi" } @all_themes;
        unless ($theme) {
            # fallback: substring match (case-insensitive), choose shortest match
            my @matches = grep { index(lc($_), lc($arg)) != -1 } @all_themes;
            if (@matches) {
                @matches = sort { length($a) <=> length($b) } @matches;
                $theme = $matches[0];
            } else {
                print "No theme found for '$arg'\n";
            }
        }
    }

    unless($theme) {
        $theme = `ls $colors_dir | fzf`;
        chomp $theme;
    }

    if ($theme) {
        print "\'$theme\' rofi theme selected\n";
        $theme =~ s/\.rasi$//;

        find( \&wanted, $dir);
        foreach my $f (@all_config_files) {
            update_file($f);
        }
    } else {
        print "No theme selected\n";
    }
}

main()
