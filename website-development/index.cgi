#!c:/strawberry/perl/bin/perl.exe

use strict;
use warnings;

use base 'ThinWeb';

sub index {
      my $self = shift;
      
      $self->stash('title', "&nbsp;This is a stash value!");
}

main->start;

__DATA__

@@ layout/default.tmpl
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
  <title>asdas</title>
</head>
<body>
[% content %]
</body>
</html>


@@ index.tmpl
[% layout 'default' %]
<span style="color: #333">Index Page</span>[% title %]

