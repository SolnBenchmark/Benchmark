# SolnBenchmark
SolnBenchmark provides a means to evaluate performance of localization algorithms for stochastic optical localization nanoscopy (SOLN).

A variety of data frames and data movies are synthesized and simulate experiments. 

A participant algorithm estimates emitter locations from a data frame or data movie and generates a SOLN image consists of the estimated emitter locations. 

The algorithm developer submits the estimated SONL image. 

The quality of a submitted SOLN image is evaluated by the metric of root mean square minimum distance (RMSMD) by comparison with the truth emitter locations. 

The RMSMD and rank of a participant algorithm are listed in the leaderborads. 

The performance and rank are benchmarked by the information-achieving unbiased Gaussian (IAUG) estimator that achieves the Fisher information and the Cramer-Rao lower bound (CRLB) of a data frame. 

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

# Participants

|Algorithm |Participant |Affiliation |Country |
|:-------:|:------:|:--------:|:-----:|
|IAUG     |Yi Sun | The City College of New York |USA |

# Reference and citation
[1] Y. Sun, "Localization precision of stochastic optical localization nanoscopy using single frames," J. Biomed. Optics, vol. 18, no. 11, pp. 111418-14, Oct. 2013.

[2] Y. Sun, "Root mean square minimum distance as a quality metric for stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, no. 1, pp. 17211, Nov. 2018.

# Contact

Yi Sun, Electrical Engineering Department, Nanoscopy Laboratory, The City College of City University of New York, New York, NY 10031, USA
