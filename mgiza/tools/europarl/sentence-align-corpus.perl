#!/usr/bin/perl -w

use strict;
use Encode;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");


my $dir = "txt";
my $outdir = "aligned";
my $preprocessor = "tools/split-sentences.perl -q";

my ($l1,$l2) = @ARGV;
die unless -e "$dir/$l1";
die unless -e "$dir/$l2";

`mkdir -p $outdir/$l1-$l2/$l1`;
`mkdir -p $outdir/$l1-$l2/$l2`;

my ($dayfile,$s1); # globals for reporting reasons
open(LS,"ls $dir/$l1|");
while($dayfile = <LS>) {
  chop($dayfile);
  if (! -e "$dir/$l2/$dayfile") {
    print "$dayfile only for $l1, not $l2, skipping\n";
    next;
  }
  &align();
}

sub align {
  my @TXT1native= `$preprocessor -l $l1 < $dir/$l1/$dayfile`;
  my @TXT2native = `$preprocessor -l $l2 < $dir/$l2/$dayfile`;
  my @TXT1;
  my @TXT2;
  
  
  #change perl encoding
  foreach my $line (@TXT1native) {
  	push(@TXT1,decode_utf8($line));
  }
foreach my $line (@TXT2native) {
  	push(@TXT2,decode_utf8($line));
  }  
  
  open(OUT1, ">$outdir/$l1-$l2/$l1/$dayfile");
  open(OUT2, ">$outdir/$l1-$l2/$l2/$dayfile");
  
  	binmode(OUT1, ":utf8");
	binmode(OUT2, ":utf8");


  for(my $i2=0,my $i1=0; $i1<scalar(@TXT1) && $i2<scalar(@TXT2);) {
    
    # match chapter start
    if ($TXT1[$i1] =~ /^<CHAPTER ID=\"?(\d+)\"?/) {
      my $c1 = $1;
      #print "CHAPTER $1\n";
      if ($TXT2[$i2] =~ /^<CHAPTER ID=\"?(\d+)\"?/) {
	my $c2 = $1;
	if ($c1 == $c2) {
	  print OUT1 $TXT1[$i1++];
	  print OUT2 $TXT2[$i2++];
	}
	elsif ($c1 < $c2) {
	  $i1 = &skip(\@TXT1,$i1+1,'^<CHAPTER ID=\"?\d+\"?');
	}
	else {
	  $i2 = &skip(\@TXT2,$i2+1,'^<CHAPTER ID=\"?\d+\"?');
	}
      }
      else {
	$i2 = &skip(\@TXT2,$i2,'^<CHAPTER ID=\"?\d+\"?');
      }
    }
    
    # match speaker start
    elsif ($TXT1[$i1] =~ /^<SPEAKER ID=\"?(\d+)\"?/) {
      $s1 = $1;
      #print "SPEAKER $1\n";
      if ($TXT2[$i2] =~ /^<SPEAKER ID=\"?(\d+)\"?/) {
	my $s2 = $1;
	if ($s1 == $s2) {
	  print OUT1 $TXT1[$i1++];
	  print OUT2 $TXT2[$i2++];
	}
	elsif ($s1 < $s2) {
	  $i1 = &skip(\@TXT1,$i1+1,'^<SPEAKER ID=\"?\d+\"?');
	}
	else {
	  $i2 = &skip(\@TXT2,$i2+1,'^<SPEAKER ID=\"?\d+\"?');
	}
      }
      else {
	$i2 = &skip(\@TXT2,$i2,'^<SPEAKER ID=\"?\d+\"?');
      }
    }  
    else {
      #print "processing... $i1,$i2\n";
      my @P1 = &extract_paragraph(\@TXT1,\$i1);
      my @P2 = &extract_paragraph(\@TXT2,\$i2);
      if (scalar(@P1) != scalar(@P2)) {
	print "$dayfile (speaker $s1) different number of paragraphs ".scalar(@P1)." != ".scalar(@P2)."\n";
      }
      else {
	  for(my $p=0;$p<scalar(@P1);$p++) {
	      &sentence_align(\@{$P1[$p]},\@{$P2[$p]});
	  }
      }
    }
  }
}
close(LS);

sub skip {
  my ($TXT,$i,$pattern) = @_;
  my $i_old = $i;
  while($i < scalar(@{$TXT})
	&& $$TXT[$i] !~ /$pattern/) { 
    $i++; 
  }
  print "$dayfile skipped lines $i_old-$i to reach '$pattern'\n";
  return $i;
}

sub extract_paragraph {
  my ($TXT,$i) = @_;
  my @P = ();
  my $p=0;
  for(;$$i<scalar(@{$TXT}) 
      && ${$TXT}[$$i] !~ /^<SPEAKER ID=\"?\d+\"?/
      && ${$TXT}[$$i] !~ /^<CHAPTER ID=\"?\d+\"?/;$$i++) {
    if (${$TXT}[$$i] =~ /^<P>/) {
	$p++ if $P[$p];
	# each XML tag has its own paragraph
	push @{$P[$p]}, ${$TXT}[$$i];
	$p++;
    }
    else {
      push @{$P[$p]}, ${$TXT}[$$i];
    }
  }
  return @P;
}

# this is a vanilla implementation of church and gale
sub sentence_align {
  my ($P1,$P2) = @_;
  chop(@{$P1});
  chop(@{$P2});

  # parameters
  my %PRIOR;
  $PRIOR{1}{1} = 0.89;
  $PRIOR{1}{0} = 0.01/2;
  $PRIOR{0}{1} = 0.01/2;
  $PRIOR{2}{1} = 0.089/2;
  $PRIOR{1}{2} = 0.089/2;
#  $PRIOR{2}{2} = 0.011;
  
  # compute length (in characters)
  my (@LEN1,@LEN2);
  $LEN1[0] = 0;
  for(my $i=0;$i<scalar(@{$P1});$i++) {
    my $line = $$P1[$i];
    $line =~ s/[\s\r\n]+//g;
#    print "1: $line\n";
    $LEN1[$i+1] = $LEN1[$i] + length($line);
  }
  $LEN2[0] = 0;
  for(my $i=0;$i<scalar(@{$P2});$i++) {
    my $line = $$P2[$i];
    $line =~ s/[\s\r\n]+//g;
#    print "2: $line\n";
    $LEN2[$i+1] = $LEN2[$i] + length($line);
  }

  # dynamic programming
  my (@COST,@BACK);
  $COST[0][0] = 0;
  for(my $i1=0;$i1<=scalar(@{$P1});$i1++) {
    for(my $i2=0;$i2<=scalar(@{$P2});$i2++) {
      next if $i1 + $i2 == 0;
      $COST[$i1][$i2] = 1e10;
      foreach my $d1 (keys %PRIOR) {
	next if $d1>$i1;
	foreach my $d2 (keys %{$PRIOR{$d1}}) {
	  next if $d2>$i2;
	  my $cost = $COST[$i1-$d1][$i2-$d2] - log($PRIOR{$d1}{$d2}) +  
	    &match($LEN1[$i1]-$LEN1[$i1-$d1], $LEN2[$i2]-$LEN2[$i2-$d2]);
#	  print "($i1->".($i1-$d1).",$i2->".($i2-$d2).") [".($LEN1[$i1]-$LEN1[$i1-$d1]).",".($LEN2[$i2]-$LEN2[$i2-$d2])."] = $COST[$i1-$d1][$i2-$d2] - ".log($PRIOR{$d1}{$d2})." + ".&match($LEN1[$i1]-$LEN1[$i1-$d1], $LEN2[$i2]-$LEN2[$i2-$d2])." = $cost\n";
	  if ($cost < $COST[$i1][$i2]) {
	    $COST[$i1][$i2] = $cost;
	    @{$BACK[$i1][$i2]} = ($i1-$d1,$i2-$d2);
	  }
	}
      }
#      print $COST[$i1][$i2]."($i1-$BACK[$i1][$i2][0],$i2-$BACK[$i1][$i2][1]) ";
    }
#    print "\n";
  }
  
  # back tracking
  my (%NEXT);
  my $i1 = scalar(@{$P1});
  my $i2 = scalar(@{$P2});
  while($i1>0 || $i2>0) {
#    print "back $i1 $i2\n";
    @{$NEXT{$BACK[$i1][$i2][0]}{$BACK[$i1][$i2][1]}} = ($i1,$i2);
    ($i1,$i2) = ($BACK[$i1][$i2][0],$BACK[$i1][$i2][1]);
  }
  while($i1<scalar(@{$P1}) || $i2<scalar(@{$P2})) {
#    print "fwd $i1 $i2\n";
    for(my $i=$i1;$i<$NEXT{$i1}{$i2}[0];$i++) {
      print OUT1 " " unless $i == $i1;
      print OUT1 $$P1[$i];
    }
    print OUT1 "\n";
    for(my $i=$i2;$i<$NEXT{$i1}{$i2}[1];$i++) {
      print OUT2 " " unless $i == $i2;
      print OUT2 $$P2[$i];
    }
    print OUT2 "\n";
    ($i1,$i2) = @{$NEXT{$i1}{$i2}};
  }  
}

sub match {
  my ($len1,$len2) = @_;
  my $c = 1;
  my $s2 = 6.8;

  if ($len1==0 && $len2==0) { return 0; }
  my $mean = ($len1 + $len2/$c) / 2;
  my $z = ($c * $len1 - $len2)/sqrt($s2 * $mean);
  if ($z < 0) { $z = -$z; }
  my $pd = 2 * (1 - &pnorm($z));
  if ($pd>0) { return -log($pd); }
  return 25;
}

sub pnorm {
  my ($z) = @_;
  my $t = 1/(1 + 0.2316419 * $z);
  return 1 - 0.3989423 * exp(-$z * $z / 2) *
    ((((1.330274429 * $t 
	- 1.821255978) * $t 
       + 1.781477937) * $t 
      - 0.356563782) * $t
     + 0.319381530) * $t;
}
