#!c:/strawberry/perl/bin/perl.exe

use strict;
use warnings;

use lib './lib';
use base 'ThinWeb';

# Index Action
sub index {
	my $self = shift;
	
	$self->stash( 'title', "This is a stash value!" );
}

# Inscricao Action
sub inscricao {
	my $self = shift;
	
}

# Local Action
sub local {
	my $self = shift;
	
}

# Agenda Action
sub agenda {
	my $self = shift;
	
}

# Espalhe Action
sub espalhe {
	my $self = shift;
	
}

# Organizacao Action
sub organizacao {
	my $self = shift;
	
}

# Fotos Action
sub fotos {
	my $self = shift;
	
}

# Contato Action
sub contato {
	my $self = shift;
	
}

# Setup
sub setup {
	my $self = shift;
	
	# Portuguese
	$self->stash('PAGE_TITLE', "3a Semana de Tecnologia");

}

main->start;

__DATA__

@@ layout/default.tmpl
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
  <title>[% PAGE_TITLE %]</title>
</head>
<body>
[% content %]
</body>
</html>

@@ index.tmpl
[% layout 'default' %]
Pagina de Index

@@ inscricao.tmpl
[% layout 'default' %]
Pagina de Inscricao

@@ local.tmpl
[% layout 'default' %]
Pagina de local

@@ agenda.tmpl
[% layout 'default' %]
Pagina de agenda

@@ espalhe.tmpl
[% layout 'default' %]
Pagina de espalhe

@@ organizacao.tmpl
[% layout 'default' %]
Pagina de organizacao

@@ fotos.tmpl
[% layout 'default' %]
Pagina de fotos

@@ contato.tmpl
[% layout 'default' %]
Pagina de contato