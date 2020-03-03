# SolnBenchmark
SolnBenchmark provides a means to evaluate and benchmark performance of localization algorithms for stochastic optical localization nanoscopy (SOLN). The metric of root mean square minimum distance (RMSMD) [2] evaluates the quality of a SOLN image. The unbiased Gaussian information-achieving (UGIA) estimators [1]-[3] benchmark the performance of a participant algorithm. In this way, a participant algorithm challenges the performance bound of the Fisher information. 

The UGIA-F estimator achieves the Fisher information and CRLB of a data frame [1][2].

The UGIA-M estimator achieves the Fisher information and CRLB of a data movie [3].

# Leaderboards
The leaderboards will be updated after a submission. 

## 2D Gauss

**2DGauss_SESF (single emitter single frame): RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|:-------:|:------:|:--------:|:-----:|:-----:|
|UGIA-F     | 3.01|8.74|12.03 |7.93|
|SIC      | 44.00|43.37|46.62| 44.66|

**2DGauss_MESF (multiple emitters single frame): RMSMD (nm) vs emitter density**

| Algorithm |1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|6 emt/um<sup>2</sup>|10 emt/um<sup>2</sup>|15 emt/um<sup>2</sup>|Average|
|:-------:|:------:|:--------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-F     | 9.39 |10.07 |12.16 |18.96 |28.35|15.79|
|SIC        | 44.45 |45.49 |46.57 |48.63 |50.57 |47.14|

**2DGauss_MEMF_HTR (multiple emitters multiple frames high temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |4.26  |3.51    |3.74    |3.84|
|SIC      |42.99 |42.59 |43.50 |43.03|
|UGIA-F   | 23.40 |339.31  |2407.74 |923.48|

## 2D Airy

**2DAiry_SESF (single emitter single frame): RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|:-------:|:------:|:--------:|:-----:|:-----:|
|UGIA-F   |3.08 | 9.48 |12.98|8.51|
|SIC      | 55.67 |66.91| 77.53|67.70|

**2DAiry_MESF (multiple emitters single frame): RMSMD (nm) vs emitter density**

| Algorithm |1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|6 emt/um<sup>2</sup>|10 emt/um<sup>2</sup>|15 emt/um<sup>2</sup>|Average|
|:-------:|:------:|:--------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-F   |9.70 |10.74 |17.01 |22.33 |29.13 |17.78|
|SIC      |48.28 |48.92 |51.79 |53.21 |52.46 |50.93 |

**2DAiry_MEMF_LTR (multiple emitters multiple frames low temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |3.49    |3.57    |3.54    |3.53|
|UGIA-F   | 10.36  |11.13   |13.80   |11.76|
|SIC      | 44.79 |43.69 |44.17 |44.22 |

**2DAiry_MEMF_MTR (multiple emitters multiple frames median temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |3.75   |3.50    |3.25  |3.50 |
|UGIA-F   |10.92   |12.21   |54.92 |26.02|
|SIC      |43.93 |45.11 |42.54 |43.86|

**2DAiry_MEMF_HTR (multiple emitters multiple frames high temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |3.75    |4.01    |3.81    |3.86|
|SIC      |45.52 |45.04 |44.83 |45.13|
|UGIA-F   |35.76   |136.46  |523.73  |231.98|

## 3D Astigmatic

**3DAS_SESF (single emitter single frame): RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|:-------:|:------:|:--------:|:-----:|:-----:|
|UGIA-F   |11.80 |29.54 |39.36|26.90|

**3DAS_MESF (Multiple emitters single frame): RMSMD (nm) vs SNR**

| Algorithm |0.1 emt/um<sup>2</sup>|0.3 emt/um<sup>2</sup>|0.5 emt/um<sup>2</sup>|1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|3 emt/um<sup>2</sup>|Average|
|:-------:|:------:|:--------:|:-----:|:-----:|:-----:|:-----:|:-----:|
|UGIA-F   |18.07 |22.65 |22.37 |27.57 |38.61 |69.41 |57.78|

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
The data movies, data frames, UGIA-F estimator, and UGIA-M estimators all are generated and simulated by Matlab codes. The codes for a particular evaluation and benchmark are included in the corresponding subfolder, e.g. 2DGauss_ MEMF/Codes. The functions that are called by these codes are included in the folder /MyMatlab. 

# Reference and citation
[1] Y. Sun, "Localization precision of stochastic optical localization nanoscopy using single frames," J. Biomed. Optics, vol. 18, no. 11, pp. 111418-14, Oct. 2013.

[2] Y. Sun, "Root mean square minimum distance as a quality metric for stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, no. 1, pp. 17211, Nov. 2018.

[3] Y. Sun, "[Spatiotemporal resolution as an information theoretical property of stochastic optical localization nanoscopy](https://www.researchgate.net/publication/335798848_Spatiotemporal_Resolution_as_an_Information_Theoretical_Property_of_Stochastic_Optical_Localization_Nanoscopy)," 2020 Quantitative BioImaging Conf., QBI 2020, Oxford, UK, Jan. 6-9, 2020. 

# Contact

Yi Sun, Electrical Engineering Department, Nanoscopy Laboratory, The City College of City University of New York, New York, NY 10031, USA. E-mail: ysun@ccny.cuny.edu
