package LifeGame::Field;
use strict;
use warnings;

sub new {
    my ($class, $options) = @_;
    my $self = {
        0 => [],
        1 => [],
        MAX_LOW => $options->{MAX_LOW},
        MAX_COLUMN => $options->{MAX_COLUMN},
        init_type => $options->{type} // 'gun',
        init_types => {
            gun => 'initialize_gun', },
        now => 0,
    };
    $self = bless $self, $class;
    $self->initialize;
    eval '$self->initialize_' . $self->{init_type};
    return $self;
}

sub initialize {
    my $self = shift;

    foreach my $i ( 0 .. ($self->{MAX_LOW}-1) ) {
        foreach my $j ( 0 .. ($self->{MAX_COLUMN}-1) ) {
            $self->{0}->[$i][$j] = 0;
            $self->{1}->[$i][$j] = 0;
        }
    }
    return $self;
}

sub check_life {
    my $self = shift;

    my $fields_ref = $self->{ $self->{now} };
    my $next_ref = $self->{ $self->{now} = 1 - $self->{now} };

    foreach my $i ( 0 .. ($self->{MAX_LOW}-1) ) {
        foreach my $j ( 0 .. ($self->{MAX_COLUMN}-1) ) {
            my $sum = 0;;
            if ( $i == 0 and $j == 0 ) {
                # 左上
                $sum++ if $fields_ref->[$i][$j+1];
                $sum++ if $fields_ref->[$i+1][$j];
                $sum++ if $fields_ref->[$i+1][$j+1];
                $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
            } elsif ( $i == 0 and $j == $self->{MAX_COLUMN} ) {
                # 右上
                $sum++ if $fields_ref->[$i][$j-1];
                $sum++ if $fields_ref->[$i+1][$j-1];
                $sum++ if $fields_ref->[$i+1][$j];
                $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
            } elsif ( $i == $self->{MAX_LOW} and $j == 0 ) {
                # 左下
                $sum++ if $fields_ref->[$i-1][$j];
                $sum++ if $fields_ref->[$i-1][$j+1];
                $sum++ if $fields_ref->[$i][$j+1];
                $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
            } elsif ( $i == $self->{MAX_LOW} and $j == $self->{MAX_COLUMN} ) {
                # 右下
                $sum++ if $fields_ref->[$i-1][$j-1];
                $sum++ if $fields_ref->[$i-1][$j];
                $sum++ if $fields_ref->[$i][$j-1];
                $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
            } elsif ( $i == 0 ) {
                # 一番上
                $sum++ if $fields_ref->[$i][$j-1];
                $sum++ if $fields_ref->[$i][$j+1];
                $sum++ if $fields_ref->[$i+1][$j-1];
                $sum++ if $fields_ref->[$i+1][$j];
                $sum++ if $fields_ref->[$i+1][$j+1];
                $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
            } elsif ( $i == $self->{MAX_LOW} ) {
                # 一番下
                $sum++ if $fields_ref->[$i-1][$j-1];
                $sum++ if $fields_ref->[$i-1][$j];
                $sum++ if $fields_ref->[$i-1][$j+1];
                $sum++ if $fields_ref->[$i][$j-1];
                $sum++ if $fields_ref->[$i][$j+1];
                $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
            } elsif ( $j == 0 ) {
                # 一番左
                $sum++ if $fields_ref->[$i-1][$j];
                $sum++ if $fields_ref->[$i-1][$j+1];
                $sum++ if $fields_ref->[$i][$j+1];
                $sum++ if $fields_ref->[$i+1][$j];
                $sum++ if $fields_ref->[$i+1][$j+1];
                $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
            } elsif ( $j == $self->{MAX_COLUMN} ) {
                # 一番右
                $sum++ if $fields_ref->[$i-1][$j-1];
                $sum++ if $fields_ref->[$i-1][$j];
                $sum++ if $fields_ref->[$i][$j-1];
                $sum++ if $fields_ref->[$i+1][$j-1];
                $sum++ if $fields_ref->[$i+1][$j];
                $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
            } else {
                $sum++ if $fields_ref->[$i-1][$j-1];
                $sum++ if $fields_ref->[$i-1][$j];
                $sum++ if $fields_ref->[$i-1][$j+1];
                $sum++ if $fields_ref->[$i][$j-1];
                $sum++ if $fields_ref->[$i][$j+1];
                $sum++ if $fields_ref->[$i+1][$j-1];
                $sum++ if $fields_ref->[$i+1][$j];
                $sum++ if $fields_ref->[$i+1][$j+1];
                $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
            }
        }
    }

    return $self;
}

sub check_sum {
    my ( $life, $sum ) = @_;

    if ( $life == 0 ) {
        return 1 if $sum == 3;
    } else {
        if ( $sum == 2 or $sum == 3 ) {
            return 1;
        } elsif ( $sum <= 1 or  $sum >= 4 ) {
            return 0;
        }
    }
}

sub show {
    my $self = shift;

    system('clear');
    $self->print_bar;
    foreach my $i ( 0 .. ($self->{MAX_LOW}-1) ) {
        print "| ";
        foreach my $j ( 0 .. ($self->{MAX_COLUMN}-1) ) {
            $self->{ $self->{now} }->[$i][$j] == 1 ? print '@' : print ' ';
            print ' ';
        }
        print "|\n";
    }
    $self->print_bar;

    return $self;
}

sub print_bar {
    my $self = shift;
    print "+";
    print "-" foreach ( 0 .. ($self->{MAX_COLUMN}*2) );
    print "+\n";
    return $self;
}

    sub initialize_gun {
        my $self = shift;

        my $field = $self->{0};

        $field->[5][1] = 1;
        $field->[6][1] = 1;

        $field->[5][2] = 1;
        $field->[6][2] = 1;

        $field->[5][11] = 1;
        $field->[6][11] = 1;
        $field->[7][11] = 1;

        $field->[4][12] = 1;
        $field->[8][12] = 1;

        $field->[3][13] = 1;
        $field->[9][13] = 1;

        $field->[3][14] = 1;
        $field->[9][14] = 1;

        $field->[6][15] = 1;

        $field->[4][16] = 1;
        $field->[8][16] = 1;

        $field->[5][17] = 1;
        $field->[6][17] = 1;
        $field->[7][17] = 1;

        $field->[6][18] = 1;

        $field->[3][21] = 1;
        $field->[4][21] = 1;
        $field->[5][21] = 1;

        $field->[3][22] = 1;
        $field->[4][22] = 1;
        $field->[5][22] = 1;

        $field->[2][23] = 1;
        $field->[6][23] = 1;

        $field->[1][25] = 1;
        $field->[2][25] = 1;
        $field->[6][25] = 1;
        $field->[7][25] = 1;

        $field->[3][35] = 1;
        $field->[4][35] = 1;

        $field->[3][36] = 1;
        $field->[4][36] = 1;

        return $self;
    }

1;
