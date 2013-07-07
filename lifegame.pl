use strict;
use warnings;
use Time::HiRes;

my $MAX_LOW = 40;
my $MAX_COLUMN = 40;

sub main {
  system('clear');
  print "start Life Game\n\n";
  my $fieldset = {
    0 => [],
    1 => [],
  };

 initialize_field( $fieldset->{0} );
 initialize_field( $fieldset->{1} );

 # グライダー銃
 initialize_gun( $fieldset->{0} );

 main_loop( $fieldset );

 print "\nend Life Game\n";
}

sub initialize_field {
  my $fields_ref = shift;

  foreach my $i ( 0 .. ($MAX_LOW-1) ) {
    foreach my $j ( 0 .. ($MAX_COLUMN-1) ) {
      $fields_ref->[$i][$j] = 0;
    }
  }
}

sub initialize_gun {
  my $f = shift;

  $f->[5][1] = 1;
  $f->[6][1] = 1;

  $f->[5][2] = 1;
  $f->[6][2] = 1;

  $f->[5][11] = 1;
  $f->[6][11] = 1;
  $f->[7][11] = 1;

  $f->[4][12] = 1;
  $f->[8][12] = 1;

  $f->[3][13] = 1;
  $f->[9][13] = 1;

  $f->[3][14] = 1;
  $f->[9][14] = 1;

  $f->[6][15] = 1;

  $f->[4][16] = 1;
  $f->[8][16] = 1;

  $f->[5][17] = 1;
  $f->[6][17] = 1;
  $f->[7][17] = 1;

  $f->[6][18] = 1;

  $f->[3][21] = 1;
  $f->[4][21] = 1;
  $f->[5][21] = 1;

  $f->[3][22] = 1;
  $f->[4][22] = 1;
  $f->[5][22] = 1;

  $f->[2][23] = 1;
  $f->[6][23] = 1;

  $f->[1][25] = 1;
  $f->[2][25] = 1;
  $f->[6][25] = 1;
  $f->[7][25] = 1;

  $f->[3][35] = 1;
  $f->[4][35] = 1;

  $f->[3][36] = 1;
  $f->[4][36] = 1;
}

sub main_loop {
  my $fieldset = shift;

  my $now = 0;

  foreach my $i ( 1 .. 200 ) {
    Time::HiRes::sleep(0.1);
    print_field( $fieldset->{$now} );
    check_life( $fieldset->{$now}, $fieldset->{ ( $now = 1 - $now ) } );
    print "$i G\n";
  }
}

sub check_life {
  my ( $fields_ref, $next_ref ) = @_;

  foreach my $i ( 0 .. ($MAX_LOW-1) ) {
    foreach my $j ( 0 .. ($MAX_COLUMN-1) ) {
      my $sum = 0;;
      if ( $i == 0 and $j == 0 ) {
        # 左上
        $sum++ if $fields_ref->[$i][$j+1];
        $sum++ if $fields_ref->[$i+1][$j];
        $sum++ if $fields_ref->[$i+1][$j+1];
        $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
      } elsif ( $i == 0 and $j == $MAX_COLUMN ) {
        # 右上
        $sum++ if $fields_ref->[$i][$j-1];
        $sum++ if $fields_ref->[$i+1][$j-1];
        $sum++ if $fields_ref->[$i+1][$j];
        $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
      } elsif ( $i == $MAX_LOW and $j == 0 ) {
        # 左下
        $sum++ if $fields_ref->[$i-1][$j];
        $sum++ if $fields_ref->[$i-1][$j+1];
        $sum++ if $fields_ref->[$i][$j+1];
        $next_ref->[$i][$j] = check_sum( $fields_ref->[$i][$j], $sum );
      } elsif ( $i == $MAX_LOW and $j == $MAX_COLUMN ) {
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
      } elsif ( $i == $MAX_LOW ) {
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
      } elsif ( $j == $MAX_COLUMN ) {
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

sub print_field {
  my $fields_ref = shift;

  system('clear');
  print_bar();
  foreach my $i ( 0 .. ($MAX_LOW-1) ) {
    print "| ";
    foreach my $j ( 0 .. ($MAX_COLUMN-1) ) {
      $fields_ref->[$i][$j] == 1 ? print '@' : print ' ';
      print ' ';
    }
    print "|\n";
  }
  print_bar();

  return;
}

 sub print_bar {
   print "+";
   print "-" foreach ( 0 .. ($MAX_COLUMN*2) );
   print "+\n";
 }

 main;
