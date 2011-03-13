//
//  Distributions.m
//  Finance
//
//  Created by Richard Lewis on 5/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FTDistributions.h"
#import <math.h>

@implementation FTDistributions


+ (double)normalPdf:(double)x
{
	return [FTDistributions normalPdf:x withMean:0 withStd: 1];
}

+ (double)normalPdf:(double)x withMean:(double)mean withStd: (double)std
{
	return 1.0/(sqrt(2*M_PI)*std) * exp(-(x-mean)*(x-mean)/(2*std*std));
}

+(double)normal:(double)x
{
	return 0.5 * erfc(-x/M_SQRT2);
}

+(double)normal2:(double)x
{
	double CND = 0.0;
	double SumA, SumB, Exponential;
	
	double y = fabs(x);
	
	if (y <= 37)
	{
		Exponential = exp(-(y * y) / 2.0);
		
		if (y < 7.07106781186547) 
		{
			SumA = 3.52624965998911E-02 * y + 0.700383064443688;
			SumA = SumA * y + 6.37396220353165;
			SumA = SumA * y + 33.912866078383;
			SumA = SumA * y + 112.079291497871;
			SumA = SumA * y + 221.213596169931;
			SumA = SumA * y + 220.206867912376;
			
			SumB = 8.83883476483184E-02 * y + 1.75566716318264;
			SumB = SumB * y + 16.064177579207;
			SumB = SumB * y + 86.7807322029461;
			SumB = SumB * y + 296.564248779674;
			SumB = SumB * y + 637.333633378831;
			SumB = SumB * y + 793.826512519948;
			SumB = SumB * y + 440.413735824752;
			CND = Exponential * SumA / SumB;
		}
		else
		{
			SumA = y + 0.65;
			SumA = y + 4 / SumA;
			SumA = y + 3 / SumA;
			SumA = y + 2 / SumA;
			SumA = y + 1 / SumA;
			CND = Exponential / (SumA * 2.506628274631);
		}
	}
	if (x > 0) 
		CND = 1 - CND;

	return CND;
}

+(double) bivariate:(double) x y: (double) y rho: (double) rho
{	
	const double XX[10][3] = {
		{-0.932469514203152,-0.981560634246719, -0.993128599185095},
		{-0.661209386466265,-0.904117256370475,-0.904117256370475},
		{-0.238619186083197,-0.769902674194305,-0.912234428251326},
		{0.0,-0.587317954286617,-0.839116971822219},
		{0.0,-0.36783149899818,-0.746331906460151},
		{0.0,-0.125233408511469,-0.636053680726515},
		{0.0,0.0,-0.510867001950827},
		{0.0,0.0,-0.37370608871542},
		{0.0,0.0,-0.227785851141645},
		{0.0,0.0,-7.65265211334973E-02}
	};
	
	const double W[10][3] = {
		{0.17132449237917,4.71753363865118E-02,1.76140071391521E-02},
		{0.360761573048138,0.106939325995318,4.06014298003869E-02},
		{0.46791393457269,0.160078328543346,6.26720483341091E-02},
		{0.0,0.203167426723066,8.32767415767048E-02},
		{0.0,0.233492536538355,0.10193011981724},
		{0.0,0.249147045813403,0.118194531961518},
		{0.0,0.0,0.131688638449177},
		{0.0,0.0,0.142096109318382},
		{0.0,0.0,0.149172986472604},
		{0.0,0.0,0.152753387130726}
	};
	
	unsigned NG,LG;
	
	if (fabs(rho) < 0.3) {
		NG = 0;
		LG = 2;
	}
	else if (fabs(rho) < 0.75) {
		NG = 1;
		LG = 5;
	}
	else {
		NG = 2;
		LG = 9;
	}
	
	double h = -x;
	double k = -y;
	double hk = h * k;
	
	double BVN = 0.0;
	
	if (fabs(rho) < 0.925) {
		if (fabs(rho) > 0) {
			double hs = (h * h + k * k) / 2.0;
			double asr = asin(rho);
			for (int i=0; i<= LG; i++) {
				for (int ISs = -1; ISs<=1; ISs+=2) {
					double sn = sin(asr * (ISs * XX[i][NG] + 1) / 2);
					BVN = BVN + W[i][NG] * exp((sn * hk - hs) / (1 - sn * sn));
				}
			}
			BVN = BVN * asr / (4 * M_PI);
		}
		BVN = BVN + [FTDistributions normal:-h] * [FTDistributions normal: -k];
	}
	else {
		if (rho < 0) {
			k = -k;
			hk = -hk;
		}
		if (fabs(rho) < 1) {
			double Ass = (1 - rho) * (1 + rho);
			double A = sqrt(Ass);
			double bs = (h - k) * (h - k);
			double c = (4 - hk) / 8;
			double d = (12 - hk) / 16;
			double asr = -(bs / Ass + hk) / 2;
			if (asr > -100) 
				BVN = A * exp(asr) * (1 - c * (bs - Ass) * (1 - d * bs / 5) / 3 + c * d * Ass * Ass / 5);
			if (-hk < 100) {
				double b = sqrt(bs);
				BVN = BVN - exp(-hk / 2) * sqrt(2 * M_PI) * [FTDistributions normal: -b / A] * b * (1 - c * bs * (1 - d * bs / 5) / 3);
			}
			A = A / 2;
			for (int i=0; i<= LG; i++) {
				for (int ISs = -1; ISs<=1; ISs+=2) {
					double x1 = A * (ISs * XX[i][NG] + 1);
					double xs = x1 * x1;
					double rs = sqrt(1 - xs);
					double asr = -(bs / xs + hk) / 2;
					if (asr > -100)
						BVN = BVN + A * W[i][NG] * exp(asr) * (exp(-hk * (1 - rs) / (2 * (1 + rs))) / rs - (1 + c * xs * (1 + d * xs)));
				}
			}
			BVN = -BVN / (2 * M_PI);
		}
		if (rho > 0)
			BVN = BVN + [FTDistributions normal: -(fmax(h, k))];
		else {
			BVN = -BVN;
			if (k > h) BVN = BVN + [FTDistributions normal:k] - [FTDistributions normal:h];
		}
	}
	
	return BVN;
}

@end
