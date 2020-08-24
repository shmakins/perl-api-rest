package PerlRest::App::Model::Transaction;

use strict;
use warnings;
use parent 'Catalyst::Model::DBI';
use Data::Dumper;


__PACKAGE__->config(
  dsn           => 'dbi:SQLite:dbname=:memory:',
  user          => '',
  password      => '',
  options       => {},
);



=head1 NAME

PerlRest::App::Model::Transaction - DBI Model Class

=head1 SYNOPSIS

See L<PerlRest::App>

=head1 DESCRIPTION

DBI Model Class.

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
# Using DB in memory, I have some problems to initialize during the app startup, this is not necessary with a real DB.
my $initialize = sub {
    my $self = shift;
    $self->dbh->do("CREATE TABLE IF NOT EXISTS transactions (
        id     INTEGER PRIMARY KEY,
        type   VARCHAR(25),
        amount FLOAT(10,2),
        effectiveDate DATETIME,
        balance FLOAT(10,2)
        )");
};

# Return all transactions
sub fetch {
    my $self = shift;
    $self->$initialize();

    my @results = $self->dbh->selectall_arrayref("SELECT id, type, amount, effectiveDate, balance FROM transactions WHERE 1=1 ORDER BY id DESC;", {Slice => {} });

    return @results;
}

# Find transaction and return an simple element to check if exist or not
sub find {
    my $self = shift;
    $self->$initialize();

    my $id = $_[0];
    my $results = $self->dbh->selectrow_arrayref("SELECT id, type, amount, effectiveDate, balance FROM transactions WHERE id = $id LIMIT 1;");

    return $results;
}

# Add transaction and update balance
sub addTransaction {
    my $self = shift;
    $self->$initialize();

    my ($type, $amount, $effectiveDate) = @_;

    my $sth = $self->dbh->prepare("INSERT INTO transactions (type,amount,effectiveDate) VALUES (?,?,?)");
    $sth->execute( $type, $amount, $effectiveDate );

    $self->dbh->do("UPDATE transactions SET balance = ifnull( ( SELECT ifnull(balance,0) FROM transactions ROWPRIOR WHERE ROWPRIOR.id = (transactions.id -1 )),0) + amount;");

}

# Get balance
sub getBalance {
    my $self = shift;
    $self->$initialize();

    my $balance = $self->dbh->selectall_arrayref("SELECT balance FROM transactions ORDER BY id DESC LIMIT 1")->[0][0];

    if($balance == undef) {
        $balance = 0.00;
    }

    return $balance;

}



1;
