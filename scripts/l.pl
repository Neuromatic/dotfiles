#!/usr/bin/perl

use strict;
no strict "refs";
use warnings;

# ls specific
my $ls_bin	=	'/bin/ls';
my $ls_args	=	'-hl --group-directories-first --color=always ' .
				'--time=ctime --time-style=+%s';

# options
my %view_map = (
	"--pf"		=> "perm_file",
	"--psf"		=> "perm_size_file",
	"--ptsf"	=> "perm_time_size_file",
	"--tpf"		=> "time_perm_file",
	"--tpsf"	=> "time_perm_size_file",
	"--tsf"		=> "time_size_file",
	"--tf"		=> "time_file",
);

my (@c, @d, $view, $padding);

if (!(exists($ENV{DISPLAY})) and ($ENV{TERM} =~ m/^linux/)) {
	# delimiters
	@d = ('|', '-', ' ', '|');

	# colortheme
	@c = (
		33, # delimiter, month
		31, # minute
		32, #
		33, # hour
		34, # sec
		35, # day
		36, #
		37, # perms, size
	);

	# push bold and set normal weight
	map {
		$_ = "\e[$_";
		push(@c, "$_;01m");
		$_ = $_ . ';22m'
	} @c;

	# colorize delimiters
	map {
		$_ = $c[0] . $_
	} @d;

	# default padding and view
	$padding = 30;
	$view = $view_map{'--tpf'};
}
else {
	# delimiters
	@d = ('▕', '-', '│', '▏');
	#@d = (' ', ' ', ' ', ' ');

	# dark terminal
	#@c = (
		#237, # delimiter, month
		#196, # minute
		#240, #
		#208, # hour
		#075, # sec
		#240, # day
		#185, #
		#255, # perms, size
	#)

	# bright terminal
	@c = (
		8, # delimiter, month
		1, # minute
		240, #
		8, # hour
		1, # sec
		240, # day
		8, #
		0, # perms, size
	);

	# push bold and set normal weight
	map {
		$_ = "\e[38;5;$_";
		push(@c, "$_;01m");
		$_ = $_ . ';22m'
	} @c;

	# colorize delimiters
	map {
		$_ = $c[0] . $_
	} @d;

	# default padding and view
	$padding = 38;
	$view = $view_map{'--tf'};
}

# for every element in argv, unset if an argument for this script
map {
	if ($view_map{$_}) {
		$view = $view_map{$_};
		$_ = "";
	}
} @ARGV;

ls(time());

# 
sub ls {
	my ($time) = @_;
	my ($perm, $hlink, $user, $group, $size, $seconds, $file, $rel);

	open(my $ls, '-|', "$ls_bin $ls_args @ARGV")
		or die("Cant open $ls_bin: $!");

	while (my $line = <$ls>) {
		next if $line =~ /^total/;

		($perm, $hlink, $user, $group, $size, $seconds) = split(/\s+/, $line)
			unless $line =~ /^\s/;

		($file) = $line =~ m/.* \d{6,}? (.+)/;

		next if !$file;

		# calculate relative time
		$rel = relative_time($time, $seconds);

		# colorize size
		$size = size($size);

		# colorize permissions
		$perm = perm($perm);

		# print it
		&{$view}($perm, $rel, $size, $file);
	}

	close $ls;
}

# view: permissions and filename
# | <perm> | <filename>
sub perm_file {
	my ($perm, $rel, $size, $file) = @_;

	printf("%s%s%s%s\n",
		$d[0],
		$perm,
		$d[3],
		$file
	);
}

# view: permissions, size and filename
# | <perm> | <size> | <filename>
sub perm_size_file {
	my ($perm, $rel, $size, $file) = @_;

	printf("%s%s%s%s%s%s\n",
		$d[0],
		$perm,
		$d[3],
		$size,
		$d[2],
		$file
	);
}

# view: permissions, time, size and filename
# <time> | <perm> | <filename>
sub time_perm_file {
	my ($perm, $rel, $size, $file) = @_;

	printf("%s%s%s%s%s\n",
		$rel,
		$d[0],
		$perm,
		$d[3],
		$file
	);
}

# view: permissions, time, size and filename
# | <perm> | <size> | <filename>
sub perm_time_size_file {
	my ($perm, $rel, $size, $file) = @_;

	printf("%s %s%s%s%s%s%s%s\n",
		$d[0],
		$perm,
		$d[3],
		$rel,
		$d[2],
		$size,
		$d[2],
		$file,
	);
}

# view: time, permissions, size and filename
# <time> | <perm> | <size> | <filename>
sub time_perm_size_file {
	my ($perm, $rel, $size, $file) = @_;

	printf("%s%s%s%s%s%s%s\n",
		$rel,
		$d[0],
		$perm,
		$d[3],
		$size,
		$d[2],
		$file
	);
}


# view: time, size and filename
# <time> | <size> | <filename>
sub time_size_file {
	my ($perm, $rel, $size, $file) = @_;

	printf("%s%s%s%s%s\n",
		$rel,
		$d[0],
		$size,
		$d[2],
		$file
	);
}


# view: time and filename
# <time> | <filename>
sub time_file {
	my ($perm, $rel, $size, $file) = @_;

	printf("%s%s %s\n",
		$rel,
		$d[0],
		$file
	);
}

# colorize permissions
sub perm {
	my ($perm) = @_;

	$perm =~ s/-/$d[1]/g;
	$perm =~ s/(r)/$c[7] . $1/eg;
	$perm =~ s/(w)/$c[7] . $1/eg;
	$perm =~ s/(x)/$c[7] . $1/eg;

	$perm =~ s/(d)/$c[15] . $1/eg;
	$perm =~ s/(l)/$c[15] . $1/eg;
	$perm =~ s/(s)/$c[7] . $1/eg;
	$perm =~ s/(S)/$c[7] . $1/eg;
	$perm =~ s/(t)/$c[7] . $1/eg;
	$perm =~ s/(T)/$c[7] . $1/eg;

	return $perm;
}

# size format
sub size_format {
	my ($string, $unit) = @_;

	return sprintf("% ${padding}s ", $string . $unit)
}

# colorize size
sub size {
	my ($size) = @_;

	return size_format($c[7] . $1, $c[15] . $2)
	if $size =~ m/^(\S+)(K)/;

	return size_format($c[7] . $1, $c[15] . $2)
	if $size =~ m/^(\S+)(M)/;

	return size_format($c[7] . $1, $c[15] . $2)
	if $size =~ m/^(\S+)(G)/;

	return size_format($c[7] . $1, $c[15] . 'B')
	if $size =~ m/^(\d+)/;

	return $size;
}

# time format
sub relative_time_format {
	my ($color, $string, $unit) = @_;

	return sprintf("%s%-3s%-3s", $color, $string, $unit);
}

# colorize time
sub relative_time {
	my ($cur, $sec) = @_;
	my ($delta, $unit, $ret);

	$delta = $cur - $sec;

	# 0 < sec < 60
	$unit = "sec ";
	$ret = $delta;

	return relative_time_format($c[12], "<", $unit)
	if $delta < 10;
	return relative_time_format($c[12], $ret, $unit)
	if $delta < 60;

	# 1 < min < 45
	$unit = "min ";
	$ret = int($ret/60);

	return relative_time_format($c[9], "<", $unit)
	if $delta < 2 * 60;
	return relative_time_format($c[9], $ret, $unit)
	if $delta < 45 * 60;

	# 0.75 < hour < 42
	$unit = "hour";
	$ret = int($ret/60);

	return relative_time_format($c[11], "<", $unit)
	if $delta < 90 * 60;
	return relative_time_format($c[11], $ret, $unit)
	if $delta < 36 * 60 * 60;
	# < bold

	# 0.75 < day < 30
	$unit = "day ";
	$ret = int($ret/24);

	return relative_time_format($c[5], "<", $unit)
	if $delta < 48 * 60 * 60;
	return relative_time_format($c[5], $ret, $unit)
	if $delta < 30 * 24 * 60 * 60;

	# 1 < month < 12
	$unit = "mon ";
	$ret = int($ret/30);

	return relative_time_format($c[5], "<", $unit)
	if $delta < 2 * 30 * 24 * 60 * 60;
	return relative_time_format($c[5], $ret, $unit)
	if $delta < 12 * 30 * 24 * 60 * 60;

	# 1 < years < inf
	$unit = "year";
	$ret = int($ret/12);

	return relative_time_format($c[0], $ret, $unit);
}
