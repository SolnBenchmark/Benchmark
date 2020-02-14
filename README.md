# SolnBenchmark
SolnBenchmark provides a means to evaluate and benchmark performance of localization algorithms for stochastic optical localization nanoscopy (SOLN). The metric of root mean square minimum distance (RMSMD) [2] evaluates the quality of a SOLN image. The unbiased Gaussian information-achieving (UGIA) estimators [1]-[3] benchmark the performance of a participant algorithm. In this way, a participant algorithm challenges the performance bound of the Fisher information. 

The UGIA-F estimator achieves the Fisher information and CRLB of a data frame [1][2].

The UGIA-M estimator achieves the Fisher information and CRLB of a data movie [3].

# Leaderboards
The leaderboards will be updated after a submission. 

## 2D: Single emitter single frame

**SESF2DGauss - Single Emitter Single Frame 2D Gaussian PSF: RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|:-------:|:------:|:--------:|:-----:|:-----:|
|UGIA-F     |3.05   |8.86     |12.41 |8.10  |
|SIC      |44.37  |44.10    |50.45 |46.31|

**SESF2DAiry - Single Emitter Single Frame 2D Airy PSF: RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|:-------:|:------:|:--------:|:-----:|:-----:|
|UGIA-F     |3.05|9.34|13.07|8.49|
|SIC      |56.96|65.34|78.15|66.82|

## 2D: Multiple emitters single frame

**MESF2DGauss - Multiple Emitter Single Frame 2D Gaussian PSF: RMSMD (nm) vs emitter density**

| Algorithm |1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|6 emt/um<sup>2</sup>|10 emt/um<sup>2</sup>|15 emt/um<sup>2</sup>|Average|
|:-------:|:------:|:--------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-F     |9.39   |10.06     |12.09 |19.26  |29.02 |15.96|
|SIC        |44.45  |45.49     |46.57 |48.63  |50.56 |47.14|

## 2D: Multiple emitters multiple frames

**MEMF2DGauss - Multiple Emitter Multiple Frames 2D Gaussian PSF: RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |3.96   |4.08   | 3.82  |3.95|
|UGIA-F   |15.97  |26.11  | 75.28 |39.12|
|SIC      |41.40  |38.66  | 38.92 |39.66|

# Method
A variety of data frames and data movies that simulate experiments are synthesized. 

A participant algorithm estimates emitter locations from a data frame or a data movie and generates a SOLN image consisting of a list of the estimated emitter locations. 

The participant submits the estimated SOLN image. 

The quality of a submitted SOLN image is evaluated by RMSMD in comparison with the true emitter locations. 

The rank and RMSMD of a participant algorithm are listed in the leaderboards. 

# Group
Join the group discussion and receive announcements: [Soln Benchmark](https://groups.google.com/forum/#!forum/soln-benchmark)

# Participants

|Algorithm |Participant |Affiliation |Country |
|:-------:|:------:|:--------:|:-----:|
|UGIA-M     |Yi Sun | Electrical Engineering Department, The City College of New York |USA |
|UGIA-F     |Yi Sun | Electrical Engineering Department, The City College of New York |USA |
|SIC      |Yi Sun | Electrical Engineering Department, The City College of New York |USA |

# Matlab Codes
The data movies, data frames, UGIA-F estimator, and UGIA-M estimators all are generated and simulated by Matlab codes. The codes for a particular evaluation and benchmark are included in the corresponding subfolder, e.g. MEMF2DGauss/Codes. The functions that are called by these codes are included in the folder /MyMatlab. 

# Reference and citation
[1] Y. Sun, "Localization precision of stochastic optical localization nanoscopy using single frames," J. Biomed. Optics, vol. 18, no. 11, pp. 111418-14, Oct. 2013.

[2] Y. Sun, "Root mean square minimum distance as a quality metric for stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, no. 1, pp. 17211, Nov. 2018.

[3] Y. Sun, "[Spatiotemporal resolution as an information theoretical property of stochastic optical localization nanoscopy](https://www.researchgate.net/publication/335798848_Spatiotemporal_Resolution_as_an_Information_Theoretical_Property_of_Stochastic_Optical_Localization_Nanoscopy)," 2020 Quantitative BioImaging Conf., QBI 2020, Oxford, UK, Jan. 6-9, 2020. 

# Contact

Yi Sun, Electrical Engineering Department, Nanoscopy Laboratory, The City College of City University of New York, New York, NY 10031, USA. E-mail: ysun@ccny.cuny.edu
