#!/usr/local/bin/perl
use List::Util qw( sum );
use Math::Complex;
#use List::MoreUtils qw'pairwise'; #says cant locate
use strict;
use warnings;
	
	my $SIZE;
	#average of an array
	sub E{ 
		sum(@_)/@_ ;
	} 
	
	#return arr version of a input data file, input parameter is the file name
	sub arr {
		my @array;
		my $count = 0;
		open (my $fh, "<", @_) or die "cant open input file";
		while (<$fh>){
			foreach my $word (split) 
				{
				$array[$count] = $word;
				$count ++;
				}
		}
		$SIZE = $count; # size of the array
		return @array;
		close $fh;
	}
	# array diff
	sub diff (\@\@){
		#my ($aref, $bref) = @_;
		my @aref = @{$_[0]};
		my @bref = @{$_[1]};
		my @diff;
		my $count = 0;
		while ($count < $SIZE){
			$diff[$count] = $aref[$count] - $bref[$count];
			$count++;
		}
		return @diff;
	}
	
	#array mulit
	sub mult{
		my @aref = @{$_[0]};
		my @bref = @{$_[1]};
		my @diff;
		my $count = 0;
		while ($count < $SIZE){
			$diff[$count] = $aref[$count] * $bref[$count];
			$count++;
		}
		return @diff;
	}
	
	# variance array 
	sub sigma_sqr (\@\$){
		#my ($aref, $bref) = @_;
		my @aref = @{$_[0]};
		my $u = ${$_[1]};
		my @sigma_sqr;
		my $count = 0;
		while ($count < $SIZE){
			$sigma_sqr[$count] = ($aref[$count] - $u)**2;
			$count++;
		}
		return @sigma_sqr;
	}
	
	#auto-covariance, array,u,tao
	sub covar (\@\$\$){
		my @aref = @{$_[0]};
		my $u = ${$_[1]};
		my $t = ${$_[2]};
		my @output;
		my $count = $t; # starts from [tao]element
		while ($count < $SIZE){
			$output[$count-$t] = ($aref[$count] - $u)*($aref[$count-$t] - $u);
			$count++;
		}
		return @output;
	}
	
	#cross correlation, arr1, u1, arr2, u2,tao
	sub cross (\@\$\@\$\$){
		my @aref = @{$_[0]};
		my $u1 = ${$_[1]};
		my @bref = @{$_[2]};
		my $u2 = ${$_[3]};
		my $t = ${$_[4]};
		my @output;
		my $count = $t; # starts from [tao]element
		while ($count < $SIZE){
			$output[$count-$t] = ($aref[$count] - $u1)*($bref[$count-$t] - $u2);
			$count++;
		}
		return @output;
	}
	
	my $zero=0; # tao = 1,2,3,4,5
	my $one=1;
	my $two=2;
	my $three=3;
	my $four=4;
	my $five=5;
	
#(a), stats of X1, X2 and Y.
	my @X1 = arr('X1.txt'); #array version of input data
	my @X2 = arr('X2.txt'); #array version of input data
	my @Y = arr('Y.txt'); #array version of input data
	my $EX1 = E( @X1 );	#
	my $EX2 = E( @X2 );	#
	my $EY = E( @Y );	#
	#my @X1sigma2 = sigma_sqr (@X1, $EX1);
	#my @X2sigma2 = sigma_sqr (@X2, $EX2);
	#my @Ysigma2 = sigma_sqr (@Y, $EY);
	
	my $X1sigma2 = E( sigma_sqr (@X1, $EX1));
	my $X2sigma2 = E( sigma_sqr (@X2, $EX2));
	my $Ysigma2 = E(  sigma_sqr (@Y, $EY) );
	
##(b) auto-covariance Cyy, Cx1x1, Cx2x2, tao = 1,2,3,4,5
	my $Cx1x1_1 = E ( covar ( @X1, $EX1, $one	) );
	my $Cx1x1_2 = E ( covar ( @X1, $EX1, $two	) );
	my $Cx1x1_3 = E ( covar ( @X1, $EX1, $three	) );
	my $Cx1x1_4 = E ( covar ( @X1, $EX1, $four	) );
	my $Cx1x1_5 = E ( covar ( @X1, $EX1, $five	) );
	
	my $Cx2x2_1 = E ( covar ( @X2, $EX2, $one	) );
	my $Cx2x2_2 = E ( covar ( @X2, $EX2, $two	) );
	my $Cx2x2_3 = E ( covar ( @X2, $EX2, $three	) );
	my $Cx2x2_4 = E ( covar ( @X2, $EX2, $four	) );
	my $Cx2x2_5 = E ( covar ( @X2, $EX2, $five	) );
	
	my $Cyy_1 = E ( covar ( @Y, $EY, $one	) );
	my $Cyy_2 = E ( covar ( @Y, $EY, $two	) );
	my $Cyy_3 = E ( covar ( @Y, $EY, $three	) );
	my $Cyy_4 = E ( covar ( @Y, $EY, $four	) );
	my $Cyy_5 = E ( covar ( @Y, $EY, $five	) );
#(c) cross correlation
	my $sigmaX1 = sqrt ($X1sigma2);
	my $sigmaX2 = sqrt ($X2sigma2);
	my $sigmaY = sqrt ($Ysigma2);
	my $Rho_x1y_0 = E (cross (@X1, $EX1, @Y, $EY, $zero ) ) / ($sigmaX1 * $sigmaY);	
	my $Rho_x1y_1 = E (cross (@X1, $EX1, @Y, $EY, $one	) )	/ ($sigmaX1 * $sigmaY);	
	my $Rho_x1y_2 = E (cross (@X1, $EX1, @Y, $EY, $two	) )	/ ($sigmaX1 * $sigmaY);		
	my $Rho_x1y_3 = E (cross (@X1, $EX1, @Y, $EY, $three) )	/ ($sigmaX1 * $sigmaY);		
	my $Rho_x1y_4 = E (cross (@X1, $EX1, @Y, $EY, $four	) )	/ ($sigmaX1 * $sigmaY);		
	my $Rho_x1y_5 = E (cross (@X1, $EX1, @Y, $EY, $five	) )	/ ($sigmaX1 * $sigmaY);		

	my $Rho_x2y_0 = E (cross (@X2, $EX2, @Y, $EY, $zero ) ) / ($sigmaX2 * $sigmaY);	
	my $Rho_x2y_1 = E (cross (@X2, $EX2, @Y, $EY, $one	) ) / ($sigmaX2 * $sigmaY);	
	my $Rho_x2y_2 = E (cross (@X2, $EX2, @Y, $EY, $two	) ) / ($sigmaX2 * $sigmaY);	
	my $Rho_x2y_3 = E (cross (@X2, $EX2, @Y, $EY, $three) ) / ($sigmaX2 * $sigmaY);	
	my $Rho_x2y_4 = E (cross (@X2, $EX2, @Y, $EY, $four	) ) / ($sigmaX2 * $sigmaY);	
	my $Rho_x2y_5 = E (cross (@X2, $EX2, @Y, $EY, $five	) ) / ($sigmaX2 * $sigmaY);		

	my $Rho_x1x2_0 = E (cross (@X1, $EX1, @X2, $EX2, $zero ) )  / ($sigmaX1 * $sigmaX2);	
	my $Rho_x1x2_1 = E (cross (@X1, $EX1, @X2, $EX2, $one	) ) / ($sigmaX1 * $sigmaX2);	
	my $Rho_x1x2_2 = E (cross (@X1, $EX1, @X2, $EX2, $two	) ) / ($sigmaX1 * $sigmaX2);	
	my $Rho_x1x2_3 = E (cross (@X1, $EX1, @X2, $EX2, $three	) ) / ($sigmaX1 * $sigmaX2);	
	my $Rho_x1x2_4 = E (cross (@X1, $EX1, @X2, $EX2, $four	) ) / ($sigmaX1 * $sigmaX2);	
	my $Rho_x1x2_5 = E (cross (@X1, $EX1, @X2, $EX2, $five	) ) / ($sigmaX1 * $sigmaX2);	


#print results
open (OUT,">stats.out"); #write mode
	print OUT "E(X1) = ".$EX1."\n" ;
	print OUT "E(X1sigma2) =". $X1sigma2."\n" ;
	print OUT "E(X2) = ".$EX2."\n" ;
	print OUT "E(X2sigma2) =". $X2sigma2."\n" ;
	print OUT "E(Y) = ".$EY."\n" ;
	print OUT "E(Ysigma2) =". $Ysigma2."\n\n" ;	
	
	print OUT "Cx1x1_1 =". $Cx1x1_1."\n" ;	
	print OUT "Cx1x1_2 =". $Cx1x1_2."\n" ;	
	print OUT "Cx1x1_3 =". $Cx1x1_3."\n" ;	
	print OUT "Cx1x1_4 =". $Cx1x1_4."\n" ;	
	print OUT "Cx1x1_5 =". $Cx1x1_5."\n\n" ;	
	            
	print OUT "Cx2x2_1 =". $Cx2x2_1."\n" ;	
	print OUT "Cx2x2_2 =". $Cx2x2_2."\n" ;	
	print OUT "Cx2x2_3 =". $Cx2x2_3."\n" ;	
	print OUT "Cx2x2_4 =". $Cx2x2_4."\n" ;	
	print OUT "Cx2x2_5 =". $Cx2x2_5."\n\n" ;

	print OUT "Cyy_1 =". $Cyy_1."\n" ;	
	print OUT "Cyy_2 =". $Cyy_2."\n" ;	
	print OUT "Cyy_3 =". $Cyy_3."\n" ;	
	print OUT "Cyy_4 =". $Cyy_4."\n" ;	
	print OUT "Cyy_5 =". $Cyy_5."\n\n" ;	
	       
	print OUT "Rho_x1y_0 =". $Rho_x1y_0."\n" ;	
	print OUT "Rho_x1y_1 =". $Rho_x1y_1."\n" ;	
	print OUT "Rho_x1y_2 =". $Rho_x1y_2."\n" ;	
	print OUT "Rho_x1y_3 =". $Rho_x1y_3."\n" ;	
	print OUT "Rho_x1y_4 =". $Rho_x1y_4."\n" ;
	print OUT "Rho_x1y_5 =". $Rho_x1y_5."\n\n" ;

	print OUT "Rho_x2y_0 =". $Rho_x2y_0."\n" ;	
	print OUT "Rho_x2y_1 =". $Rho_x2y_1."\n" ;	
	print OUT "Rho_x2y_2 =". $Rho_x2y_2."\n" ;	
	print OUT "Rho_x2y_3 =". $Rho_x2y_3."\n" ;	
	print OUT "Rho_x2y_4 =". $Rho_x2y_4."\n" ;
	print OUT "Rho_x2y_5 =". $Rho_x2y_5."\n\n" ;

	print OUT "Rho_x1x2_0 =". $Rho_x1x2_0."\n" ;	
	print OUT "Rho_x1x2_1 =". $Rho_x1x2_1."\n" ;	
	print OUT "Rho_x1x2_2 =". $Rho_x1x2_2."\n" ;	
	print OUT "Rho_x1x2_3 =". $Rho_x1x2_3."\n" ;	
	print OUT "Rho_x1x2_4 =". $Rho_x1x2_4."\n" ;
	print OUT "Rho_x1x2_5 =". $Rho_x1x2_5."\n\n" ;	
		
close (OUT);	
	# to peek some array value
	#for (my $i =0; $i <10; $i++){
	#	print $X_diff2[$i]."\n";
	#}

	
	
	
