# SolnBenchmark
SolnBenchmark provides a site to evaluate the performance of localization algorithms in terms of root mean square minimum distance (RMSMD) with the benchmark of the information-achieving unbiased Gaussian (IAUG) estimator for stochastic optical localization nanoscopy (SOLN). 

The IAUG estimator achieves the Fisher infomration and the Cramer-Rao lower bound (CRLB) of a data frame. 

# Leaderboards
The leaderboards will be updated after a submission. 

**SESF2DGauss - Single Emitter Single Frame 2D Gaussian PSF**

|Algorithm|High SNR|Medium SNR|Low SNR|Average|
|:-------:|:------:|:--------:|:-----:|:-----:|
|IAUG     |3.052   |8.855     |12.407 |8.105  |


### Purpose 

# Purpose
Benchmark the performance of a localization algorithm in estimation of single isolated emitters from a single data frame. 

# Metric
Root mean square minimum distance (RMSMD) between the estimated emitter locations and the ground truth locations. 

# Benchmarking 
The information-achieving unbiased Gaussian estimator that 

# 2D Airy PSF

Data frame:
Sample size: Lx=2000, Ly=2000 (nm)
Pixel size: dx=100, dy=100 (nm)
Frame size: Kx=200, Ky=200 pixels

# References and citation
Please cite the following references:

[1] Y. Sun, "Localization precision of stochastic optical localization nanoscopy using single frames," J. Biomed. Optics, vol. 18, no. 11, pp. % 111418-14, Oct. 2013.

[2] Y. Sun, "Root mean square minimum distance as a quality metric for % stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, % no. 1, pp. 17211, Nov. 2018.
