# SolnBenchmark
SolnBenchmark provides a site to evaluate the performance of localization algorithms in terms of root mean square minimum distance (RMSMD) with the benchmark of the information-achieving unbiased Gaussian (IAUG) estimator for stochastic optical localization nanoscopy (SOLN). 

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
