#!c:/strawberry/perl/bin/perl.exe

use strict;
use warnings;

use lib './lib';
use base 'ThinWeb';

sub index {
    my $self = shift;

    $self->stash( 'title', "This is a stash value!" );
}

sub setup {
	my $self = shift;

	# English Language
	$self->stash('BTN_PUBLIC', "Create Public Post");
	$self->stash('BTN_PRIVATE', "Create Private Post");
	
	# Portuguese

}

main->start;

__DATA__

@@ layout/default.tmpl
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
  <title>[% title %]</title>
</head>
<body>
[% content %]
</body>
</html>


@@ index.tmpl
[% layout 'default' %]
<form method="post">
	<p><input name="filename" value="[% filename %]" /></p>
	<button>[% BTN_PUBLIC %]</button>&nbsp;&nbsp;<button>[% BTN_PRIVATE %]</button>
</form>

