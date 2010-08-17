# (c)copyright 2010 Daniel Vinciguerra

package ThinWeb;

use strict;
use warnings;

use base 'CGI';

sub start {
    my $class = shift;
    my $self  = $class->SUPER::new();

    # Class properties
    $self->{action}    = 'index';
    $self->{stash}     = {};
    $self->{config}    = {};
    $self->{body}      = "";
    $self->{header}    = undef;
    $self->{render}    = 0;
    $self->{templates} = {};
    $self->{layouts}   = {};

    my $process = 0;
    my $title   = '';
    my $body    = '';

    # Load all template data
    while (<main::DATA>) {

        # Verify template init
        if (m/^@@\s*(.*)\.tmpl/) {
            $process = 1;
            $title   = $1;
            $_       = '';
        }
        else {
            $process = 0;
        }

        # Define template or layout and put content
        if ( $title =~ /layout/ ) {
            $self->{layouts}->{$title} .= $_;
        }
        else {
            $self->{templates}->{$title} .= $_;
        }
    }

    # Bless self
    bless $self, $class;

    # Action call controll
    my $action = $self->param('action');
    $self->delete('action') if defined $self->param('action');
    if ( defined $action ) {
        $self->{action} = $action;
        $self->setup;
        $self->pre_cgi;
        $self->$action if $self->can($action);
        $self->pos_cgi;
    }
    else {
        $self->setup;
        $self->pre_cgi;
        $self->index;
        $self->pos_cgi;
    }

    # Fetching params and adding into stash
    for my $key ( $self->param ) {
        $self->stash( $key, $self->param($key) );
    }

    # Send default header or with params
    ( undef $self->{header} )
      ? print $self->header()
      : print $self->header( $self->{header} );

    # Output template body
    $self->render( action => $self->action );
}

sub setup { }

sub pre_cgi { }

sub pos_cgi { }

sub index { }

sub stash {
    my $self = shift;
    if ( defined $_[0] and defined $_[1] ) {
        $self->{stash}->{ $_[0] } = $_[1];
    }
    if ( defined $_[0] and !defined $_[1] ) {
        return $self->{stash}->{ $_[0] };
    }
    return $self->{stash};
}

sub body {
    my $self = shift;
    if ( defined $_[0] ) { $self->{body} = $_[0]; }
    return $self->{body};
}

sub default_header {
    my $self = shift;
    if ( defined $_[0] ) { $self->{header} = \@_; }
    return $self->{header};
}

sub action {
    my $self = shift;
    return $self->{action};
}

sub render {
    my ( $self, %param ) = @_;
    my $layout   = undef;
    my $template = undef;

    $template = $self->{templates}->{ $param{action} };

    # Define layout tag to be used
    if ( $template =~ m/\[\%\s*layout\s*'(.*)'\s*\%\]/ ) {
        $layout = $1;
        $template =~ s/\[\%\s*layout\s*'(.*)'\s*\%\]//g;
    }

    # Replace simple variables
    my %stash = %{ $self->{stash} };
    for my $key ( keys %stash ) {
        $template =~ s/\[\%\s*$key\s*\%\]/$stash{$key}/g;
    }

    # Define output body
    my $output = '';
    if ( defined $layout ) {
        $output = $self->render_layout(
            layout  => 'layout/' . $layout,
            content => $template,
        );
    }

    $self->body($output);
    print $output;
}

# Render layout
sub render_layout {
    my ( $self, %param ) = @_;
    my $layout   = undef;
    my $template = $param{content};

    # Getting informations about template and layout
    $layout = $self->{layouts}->{ $param{layout} };

    # Replace content place holder
    $layout =~ s/\[\%\s*content\s*\%\]/$template/g;

    # Replace simple variables
    my %stash = %{ $self->{stash} };
    for my $key ( keys %stash ) {
        $layout =~ s/\[\%\s*$key\s*\%\]/$stash{$key}/g;
    }

    $layout =~ s/\[\%\s*(.*)\s*\%\]//g;

    return $layout;
}

1;
__END__

=head1 NAME

ThinWeb - ThinWeb Framework CGI based likes Mojolicious::Lite

=head1 DESCRIPTION

Lightweight and ugly CGI based Web Framework that provide a simple way to use a
ThinWeb Framework to build your web solutions. I write this solution becouse
i nedded a simple and dynamic tool using cgi but I wanna make it with
minimal organization and having beware to keep simples to be maintened.

=head1 SINOPSYS
    
    use base 'ThinWeb';
    
    # This is a simple action
    sub index {
        my $self = shift;
        ...
    }
    
    sub post {
        my $self = shift;
        
        if ($self->param){
            ...
        }
    }
    
    __DATA__
    @@ index.tmpl
    <p>This is <strong>index</strong> view!!!</p>
    
    @@ post.tmpl
    <form method="post">
        Enter text here: <br />
        <input name="value" />
        <button type="submit">Send</button><br />
        Text is: [% value %]
    </form>
    

=over 4 WHAT EQUALS MOJOLICIOUS::LITE

=item action

=item view/template

=back


=over 4 ...AND WHAT'S DIFERENT

=item template engine

=item routes

=item powerfully

=item much more

=back


=head2 start

This method will be start your application make some configurations,
status check and run requested action.

    __PACKAGE__->start;


=over 4 Methods that you can override

=item setup

Setup is the first method that runned in process. This is called before action
method and can be used to configure application.

    sub setup {
        my $self = shift;
        
        # Your configurations here...
        ...
    }

=item pre_cgi

pre_cgi is the method that can be runned before action method is called by
dispatcher and can be used to configure an other Template Engine likes TT.

    sub pre_cgi {
        my $self = shift;
        
        # Your code here...
        ...
    }

=item pos_cgi

pos_cgi is the method that is called after action method finished. 

=item index



=back

=head2 stash

This method provide a simple implementation of stash that used to render view
template.

	$self->stash->{name} = 'ThinWeb Framework';
	# or use like this...
	$self->stash('name', 'ThinWeb Framework');
	
... and to get a stash item you can do

	print $self->stash('name'); # this output ThinWeb Framework

=head2 body

This method is a simple accessor to body attribute that's save a copy of
rendered view.

	print $self->body; # prints view

=head2 header



=head2 action

Action is a simple method to access action application variable and return it.

	$self->action;


=head2 render

This method provide a simple template engine based o replace of keywords in
application stash.

	$self->render( action => 'index' );

You can override this method to useyour favorite template engine likes TT,
HTML::Mason, HTML::Template, etc...

=head1 SEE ALSO

L<CGI> L<CGI::Application> L<Mojolicious::Lite>

=head1 AUTHOR

Daniel Vinciguerra <daniel-vinciguerra@hotmail.it>

=cut
