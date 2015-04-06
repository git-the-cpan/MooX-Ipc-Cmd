#ABSTRACT: Exception class for MooX::Ipc::Cmd role
package MooX::Ipc::Cmd::Exception;
use Moo;
our $VERSION = '1.0.2'; #VERSION
extends 'Throwable::Error';
has 'stderr'      => (is => 'ro', predicate => 1,);
has 'cmd'         => (is => 'ro', required  => 1,);
has 'exit_status' => (is => 'ro', required  => 1);
has 'signal'      => (is => 'ro', predicate => 1,);

use overload
  q{""}    => 'as_string',
  fallback => 1;

  #message to print when dieing
has +message => (
    is =>'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $str = join(" ", @{$self->cmd});
        if ($self->has_signal)
        {
            $str .= " failed with signal " . $self->signal;
        }
        else
        {
            $str .= " failed with exit status " . $self->exit_status;
            if ($self->has_stderr && defined $self->stderr)
            {
                $str = "\nSTDERR is :\n" . join("\n  ", @{$self->stderr});
            }
        }
        return $str;
    },
);

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MooX::Ipc::Cmd::Exception - Exception class for MooX::Ipc::Cmd role

=head1 VERSION

version 1.0.2

=head1 AUTHOR

Eddie Ash <eddie+cpan@ashfamily.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Edward Ash.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
