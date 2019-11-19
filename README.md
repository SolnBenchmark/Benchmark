# SolnBenchmark
SolnBenchmark provides a means to evaluate and benchmark performance of localization algorithms for stochastic optical localization nanoscopy (SOLN). The metric of root mean square minimum distance (RMSMD) evaluates the quality of a SOLN image. The information-achieving unbiased Gaussian (IAUG) estimator benchmarks the performance of a participant algorithm. The IAUG estimator achieves the Fisher information and the Cramer-Rao lower bound (CRLB) of a data frame.

# Leaderboards
The leaderboards will be updated after a submission. 

## Single emitter single frame

**SESF2DGauss - Single Emitter Single Frame 2D Gaussian PSF: RMSMD (nm)**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|:-------:|:------:|:--------:|:-----:|:-----:|
|IAUG     |3.052   |8.855     |12.407 |8.105  |

**SESF2DAiry - Single Emitter Single Frame 2D Airy PSF: RMSMD (nm)**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|:-------:|:------:|:--------:|:-----:|:-----:|
|IAUG     |3.052   |8.855     |12.407 |8.105  |

# Method
A variety of data frames and data movies that simulate experiments are synthesized. 

A participant algorithm estimates emitter locations from a data frame or data movie and generates a SOLN image consisting of a list of the estimated emitter locations. 

The participant submits the estimated SOLN image. 

The quality of a submitted SOLN image is evaluated by RMSMD in comparison with the true emitter locations. 

The rank and RMSMD of a participant algorithm are listed in the leaderboards. 

# Group
Join the group discussion and receive announcement: [Soln Benchmark](https://groups.google.com/forum/#!forum/soln-benchmark)

# Participants

|Algorithm |Participant |Affiliation |Country |
|:-------:|:------:|:--------:|:-----:|
|IAUG     |Yi Sun | Electrical Engineering Department, The City College of New York |USA |

# Reference and citation
[1] Y. Sun, "Localization precision of stochastic optical localization nanoscopy using single frames," J. Biomed. Optics, vol. 18, no. 11, pp. 111418-14, Oct. 2013.

[2] Y. Sun, "Root mean square minimum distance as a quality metric for stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, no. 1, pp. 17211, Nov. 2018.

# Contact

Yi Sun, Electrical Engineering Department, Nanoscopy Laboratory, The City College of City University of New York, New York, NY 10031, USA
