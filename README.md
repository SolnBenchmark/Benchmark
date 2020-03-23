# SolnBenchmark
SolnBenchmark provides a means to evaluate and benchmark performance of localization algorithms for stochastic optical localization nanoscopy (SOLN). The metric of root mean square minimum distance (RMSMD) [2] evaluates the quality of a SOLN image. The unbiased Gaussian information-achieving (UGIA) estimators [1]-[3] benchmark the performance of a participant algorithm. In this way, a participant algorithm challenges the performance bound of the Fisher information. 

The UGIA-F estimator achieves the Fisher information and CRLB of each data frame [1][2].

The UGIA-M estimator achieves the Fisher information and CRLB of a data movie [3].

# Leaderboards
The leaderboards will be updated after a submission. 

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
|UGIA-M   |3.00  |3.14  |2.96  |3.03|
|UGIA-F    |9.91  |10.12 |12.15 |10.73|
|SIC           |44.81 |48.51 |47.59 |46.97|

**2DAiry_MEMF_MTR (multiple emitters multiple frames median temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |3.29  |2.97  |3.51  |3.26|
|UGIA-F   |11.10 |11.61 |17.62 |13.44|
|SIC      |43.99 |43.71 |44.10 |43.93|

**2DAiry_MEMF_HTR (multiple emitters multiple frames high temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |3.20  |3.09    |3.44    |3.24|
|SIC           |44.79 |45.52 |44.70 |45.00|
|UGIA-F   |28.10 |50.63 |101.16  |59.96

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

**2DGauss_MEMF_LTR (multiple emitters multiple frames low temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |3.06  |2.89  |2.85  |2.93 |
|UGIA-F    |10.53 |10.55 |13.46 |11.51|
|SIC           |43.25 |39.78 |39.75 |40.93|

**2DGauss_MEMF_MTR (multiple emitters multiple frames median temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |3.24  |3.16  |3.10  |3.17|
|UGIA-F    |11.22 |12.30 |18.66 |14.06|
|SIC           |40.91 |40.05 |40.37 |40.44|

**2DGauss_MEMF_HTR (multiple emitters multiple frames high temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |3.08  |3.06    |3.36      |3.17|
|SIC            |42.99 |42.59 |43.50 |43.03|
|UGIA-F    |29.68 |49.52 |102.09  |60.43|

## 3D Astigmatic

**3DAS_SESF (single emitter single frame): RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|:-------:|:------:|:--------:|:-----:|:-----:|
|UGIA-F   |11.80 |29.54 |39.36|26.90|

**3DAS_MESF (Multiple emitters single frame): RMSMD (nm) vs SNR**

| Algorithm |0.1 emt/um<sup>2</sup>|0.3 emt/um<sup>2</sup>|0.5 emt/um<sup>2</sup>|1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|3 emt/um<sup>2</sup>|Average|
|:-------:|:------:|:--------:|:-----:|:-----:|:-----:|:-----:|:-----:|
|UGIA-F   |18.07 |22.65 |22.37 |27.57 |38.61 |69.41 |57.78|

**3DAS_MEMF_LTR (multiple emitters multiple frames low temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |6.12  |6.03  |6.45  |6.20|
|UGIA-F    |38.35 |47.28 |57.15 |47.59|

**3DAS_MEMF_MTR (multiple emitters multiple frames median temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |6.83  |6.35  |7.39  |6.86|
|UGIA-F    |54.20 |67.39 |90.72 |70.77|

**3DAS_MEMF_HTR (multiple emitters multiple frames high temporal resolution): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average (nm)|
|:-------:|:-----:|:-----:|:-----:|:-----:|
|UGIA-M   |8.82    |8.69    |9.20    |8.90|
|UGIA-F    |110.03  |133.76  |178.14  |140.64|

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
|[Cspline]( https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_ZhuangLab_storm-2Danalysis&d=DwID-g&c=4NmamNZG3KTnUCoC6InoLJ6KV1tbVKrkZXHRwtIMGmo&r=j0A6IFQM1sqhJ9JGnpoeSyUsEY4C_j3vAHGUhAHkwqc&m=KyWuibdcanyti6L5Rv5wyAfNPjtPqLpgLow4D7Hfwv0&s=D8QCk3zeetHK2OJqex-T45UyU0qNm8qUSdmB7HeK_gc&e=)|Hazhen Bobcock| Harvard Center for Advanced Imaging|USA |
|SIC      |Yi Sun | Electrical Engineering Department, The City College of New York |USA |

# Matlab Codes
The data movies, data frames, UGIA-F estimator, and UGIA-M estimator all are generated and simulated by Matlab codes. The codes for a particular evaluation and benchmark are included in the corresponding subfolder, e.g. 2DGauss_ MEMF/Codes. The functions that are called by these codes are included in the folder /MyMatlab. 

# Reference and citation
[1] Y. Sun, "Localization precision of stochastic optical localization nanoscopy using single frames," J. Biomed. Optics, vol. 18, no. 11, pp. 111418-14, Oct. 2013.

[2] Y. Sun, "Root mean square minimum distance as a quality metric for stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, no. 1, pp. 17211, Nov. 2018.

[3] Y. Sun, "[Spatiotemporal resolution as an information theoretical property of stochastic optical localization nanoscopy](https://www.researchgate.net/publication/335798848_Spatiotemporal_Resolution_as_an_Information_Theoretical_Property_of_Stochastic_Optical_Localization_Nanoscopy)," 2020 Quantitative BioImaging Conf., QBI 2020, Oxford, UK, Jan. 6-9, 2020. 

# Contact

Yi Sun, Electrical Engineering Department, Nanoscopy Laboratory, The City College of City University of New York, New York, NY 10031, USA. E-mail: ysun@ccny.cuny.edu
