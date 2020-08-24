package PerlRest::App::Controller::Transactions;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use Time::Piece;
use Scalar::Util 'looks_like_number';

BEGIN {extends 'Catalyst::Controller::REST';}

__PACKAGE__->config(default => 'text/x-json');

sub fetch_GET :GET :Path :Args(0) {
    my ($self, $c) = @_;

    my @transactions = $c->model("Transaction")->fetch();

    $self->status_ok(
        $c,
        entity => @transactions,
    );

}

sub find_GET :GET :Path :Args(1) {
    my ($self, $c, $transactionId) = @_;

    # Start parameters validation
    if (! is_number($transactionId) || $transactionId <= 0) {
        return $self->status_bad_request(
            $c,
            message => "TransactionId not allowed! We only accept a positive number."
        );
    }
    # End parameters validation

    # Get Transaction
    my $transaction = $c->model("Transaction")->find($transactionId);

    # Not Found Transaction
    if(! defined $transaction) {
        return $self->status_not_found(
                $c,
                message => "The transaction id $transactionId doesn't exist!",
            );
    }

    $self->status_ok(
        $c,
        entity => {
            id      => $transaction->[0],
            type    => $transaction->[1],
            amount  => $transaction->[2],
            effectiveDate  => $transaction->[3],
            balance => $transaction->[4]
        }
    );

}

sub create_POST :POST :Path :Args(0) {
    my ($self, $c) = @_;

    my $effectiveDate = Time::Piece::localtime->strftime('%Y-%m-%d %H:%M:%S');
    my $type = $c->request->params->{type} || 'credit';
    my $amount = $c->request->params->{amount} || 0.00;

    # Start parameters validation
    if (! is_number($amount) || $amount <= 0) {
        return $self->status_bad_request(
            $c,
            message => "Amount not allowed! We only accept a positive number."
        );
    }

    if ( ! ($type ~~ ["credit", "debit"] ) ) {
        return $self->status_bad_request(
            $c,
            message => "Type not allowed! We only accept credit or debit transaction."
        );
    }

    # Normalize number, with 2 decimals.
    $amount = sprintf("%.2f", $amount);

    if( $type eq "debit") {
        my $balance = $c->model("Transaction")->getBalance();

        if($balance - $amount < 0) {
            return $self->status_bad_request(
                $c,
                message => "Transaction not allowed! You only have \$ $balance available in your account."
            );
        }

        # We will save negative values in db when the transaction is debit.
        $amount = $amount * -1;

    }
    # End parameters validation

    # Add Transaction
    my $transactionId = $c->model("Transaction")->addTransaction($type,$amount,$effectiveDate);

    # Get last Transaction
    my $transaction = $c->model("Transaction")->find($transactionId);

    $self->status_ok(
        $c,
        entity => {
            id      => $transaction->[0],
            type    => $transaction->[1],
            amount  => $transaction->[2],
            effectiveDate  => $transaction->[3],
            balance => $transaction->[4]
        }
    );

}

sub is_number {
    my $num = shift;
    return looks_like_number($num) && $num !~ /inf|nan/i;
}

__PACKAGE__->meta->make_immutable;

1;
