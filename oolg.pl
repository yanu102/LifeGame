use strict;
use warnings;
use Time::HiRes;
use LifeGame::Field;

my $MAX_LOW = my $MAX_COLUMN = 40;
my $WAIT_TIME = 0.1;

system('clear');

my $fs = LifeGame::Field->new(
  {
    MAX_LOW => $MAX_LOW,
    MAX_COLUMN => $MAX_COLUMN,
  }
);

foreach my $i ( 1 .. 200 ) {
  Time::HiRes::sleep $WAIT_TIME;
  $fs->show->check_life;
  print "$i G\n";
}

print "\nend Life Game\n";


