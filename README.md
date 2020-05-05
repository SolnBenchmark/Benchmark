# SolnBenchmark
SolnBenchmark provides a means to evaluate and benchmark performance of localization algorithms for stochastic optical localization nanoscopy (SOLN). 

The metric of root mean square minimum distance (RMSMD) [2] evaluates the quality of a SOLN image. The metric of spatiotemporal resolution (STR) [3] evaluates the quality of a SOLN video. 

The unbiased Gaussian information-achieving (UGIA-F and UGIA-M) estimators [1]-[3] benchmark the performance of a participant algorithm. 

In this way, a participant algorithm challenges the performance bound of the Fisher information. 

The UGIA-F estimator achieves the Fisher information and CRLB of each data frame [1][2]. The UGIA-M estimator achieves the Fisher information and CRLB of a data movie [3].


# Leaderboards
The leaderboards will be updated after a submission. 

## 2D Airy

**2DAiry_SESF (single emitter single frame): RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|-------:|------:|--------:|-----:|-----:|
|UGIA-F   |3.75  |8.53 |15.86 |9.38| 
|3D-DAOSTORM|14.65 |16.56 |20.75 |17.32 |
|SIC      |44.28 |48.67 |66.97 |53.31

**2DAiry_MESF (multiple emitters single frame): RMSMD (nm) vs emitter density**

| Algorithm |0.5 emt/um<sup>2</sup>|1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|4 emt/um<sup>2</sup>|8 emt/um<sup>2</sup>|Average|
|-------:|------:|--------:|-----:|-----:|-----:|-----:|
|UGIA-F   |8.91 |9.70 |13.48 |18.28 |24.85 |15.04|
|SIC      |50.58 |51.11 |53.96 |55.87 |61.37 |54.58|
|3D-DAOSTORM|104.03 |70.94 |69.78 |99.38 |103.17 |89.46|

**2DAiry_MEMF_LTR (multiple emitters multiple frames low temporal resolution): RMSMD (nm), STR (nm<sup>2</sup>s) vs emitter distance**

|         |RMSMD|  |  |      |    |STR| | | |
|--------:|------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|**Algorithm**|**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**| |**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**|
|UGIA-M   |2.58 |2.79 |2.65 |2.67|          |965 |1123 |1017 |1035 |
|UGIA-F   |9.28 |9.57 |12.69 |10.51|        |12,461 |13,254 |23,286 |16,334 |
|SIC      |46.11 |46.28 |44.61 |45.67|      |       |       |       |     |

**2DAiry_MEMF_MTR (multiple emitters multiple frames median temporal resolution): RMSMD (nm), STR (nm<sup>2</sup>s) vs emitter distance**

|         |RMSMD|  |  |      |    |STR| | | |
|--------:|------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|**Algorithm**|**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**| |**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**|
|UGIA-M   |3.29  |2.97  |3.51  |3.26|       |554 |555 |675 |595 |
|UGIA-F   |11.10 |11.61 |17.62 |13.44|      |7,954 |1,167 |23,805 | 10,975 |
|SIC      |43.99 |43.71 |44.10 |43.93|      |       |       |       |     |

**2DAiry_MEMF_HTR (multiple emitters multiple frames high temporal resolution): RMSMD (nm), STR (nm<sup>2</sup>s) vs emitter distance**

|         |RMSMD|  |  |      |    |STR| | | |
|--------:|------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|**Algorithm**|**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**| |**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**|
|UGIA-M   |3.10 |3.32 |3.59 |3.34|          |139 |159 |187 |162 |
|SIC      |51.27 |52.57 |51.82 |51.89|      |       |       |       |     |
|UGIA-F   |36.80 |61.19 |108.90 |68.96|     |19,588 |5,417 |171,586 |65,530 |

## 2D Gauss

**2DGauss_SESF (single emitter single frame): RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|-------:|------:|--------:|-----:|-----:|
|UGIA-F     |4.11 |9.27 |17.11 |10.16 |
|3D-DAOSTORM|4.08 |9.39 |17.72 |10.40 |
|SIC      |49.38 |53.26 |66.25 |56.30|

**2DGauss_MESF (multiple emitters single frame): RMSMD (nm) vs emitter density**

| Algorithm |0.5 emt/um<sup>2</sup>|1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|4 emt/um<sup>2</sup>|8 emt/um<sup>2</sup>|Average|
|-------:|------:|--------:|-----:|-----:|-----:|-----:|
|UGIA-F     |9.76 |11.16 |12.42 |19.52 |28.49 |16.27|
|SIC        |49.62 |50.80 |53.10 |57.01 |58.66 |53.84|
|3D-DAOSTORM|103.65 |113.21 |85.28 |92.70 |123.23 |103.61|

**2DGauss_MEMF_LTR (multiple emitters multiple frames low temporal resolution): RMSMD (nm), STR (nm<sup>2</sup>s) vs emitter distance**

|         |RMSMD|  |  |      |    |STR| | | |
|--------:|------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|**Algorithm**|**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**| |**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**|
|UGIA-M   |2.95 |3.15 |3.22 |3.11 |         |1,260 |1,432 |1,496 |1,396 |
|UGIA-F   |11.85 |13.23 |12.82 |12.63 |     |20,299 |25,306 |27,624 |24,410 |
|SIC      |44.53 |42.97 |43.01 |43.50 |     |       |       |       |     |

**2DGauss_MEMF_MTR (multiple emitters multiple frames median temporal resolution): RMSMD (nm), STR (nm<sup>2</sup>s) vs emitter distance**

|         |RMSMD|  |  |      |    |STR| | | |
|--------:|------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|**Algorithm**|**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**| |**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**|
|UGIA-M   |3.31 |3.62 |3.31 |3.41|          |792 |947 |794 |844 |
|UGIA-F   |13.06 |15.49 |25.76 |18.10|      |12,338 |17,362 |47,996 |25,899|
|SIC      |45.18 |44.29 |47.80 |45.76|      |       |       |       |     |

**2DGauss_MEMF_HTR (multiple emitters multiple frames high temporal resolution): RMSMD (nm), STR (nm<sup>2</sup>s) vs emitter distance**

|         |RMSMD|  |  |      |    |STR| | | |
|--------:|------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|**Algorithm**|**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**| |**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**|
|UGIA-M   |3.64 |3.61 |4.12 |3.79|          |192 |188 |245 |208 |
|SIC      |50.79 |50.46 |49.76 |50.34|      |       |       |       |     |
|UGIA-F   |37.95 |64.41 |116.79 |73.05|     |20,837 |60,016 |197,328 |92,727 |

## 3D Astigmatic

**3DAS_SESF (single emitter single frame): RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|-------:|------:|--------:|-----:|-----:|
|UGIA-F   |11.80 |17.23 |30.30 |19.78 |

**3DAS_MESF (Multiple emitters single frame): RMSMD (nm) vs emitter density**

| Algorithm |0.1 emt/um<sup>2</sup>|0.3 emt/um<sup>2</sup>|0.5 emt/um<sup>2</sup>|1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|3 emt/um<sup>2</sup>|Average|
|-------:|------:|--------:|-----:|-----:|-----:|-----:|-----:|
|UGIA-F   |16.90 |21.44 |22.51 |25.37 |42.85 |68.90 |33.00 |

**3DAS_MEMF_LTR (multiple emitters multiple frames low temporal resolution): RMSMD, STR (nm<sup>2</sup>s) vs emitter distance**

|         |RMSMD|  |  |      |    |STR| | | |
|--------:|------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|**Algorithm**|**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**| |**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**|
|UGIA-M   |6.12  |6.03  |6.45  |6.20|       |5,424 |5,267 |6,020 |5,570 |
|UGIA-F    |38.35 |47.28 |57.15 |47.59|     |212,825 |323,361 |472,480 |336222 |

**3DAS_MEMF_MTR (multiple emitters multiple frames median temporal resolution): RMSMD (nm), STR (nm<sup>2</sup>s) vs emitter distance**

|         |RMSMD|  |  |      |    |STR| | | |
|--------:|------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|**Algorithm**|**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**| |**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**|
|UGIA-M   |6.83  |6.35  |7.39  |6.86|       |3,379 |2,915 |3,953 |3,416 |
|UGIA-F    |54.20 |67.39 |90.72 |70.77|     |212,475 |328,517 |595,339 |378,777 |

**3DAS_MEMF_HTR (multiple emitters multiple frames high temporal resolution): RMSMD (nm), STR (nm<sup>2</sup>s) vs emitter distance**

|         |RMSMD|  |  |      |    |STR| | | |
|--------:|------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|**Algorithm**|**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**| |**40 (nm)**|**30 (nm)**|**20 (nm)**|**Average**|
|UGIA-M   |8.82    |8.69    |9.20    |8.90| |2,251 |2,183 |2,447 |2,294 |
|UGIA-F    |110.03 |133.76 |178.14 |140.64| |350,305 |517,706 |948,234 |605,415 |

# Non-Blind Localization
This evaluation and benchmark is non-blind, that is, all the parameters of an optical system are known a priori, which are supposed to have been obtained through a calibration. Nevertheless, a blind localization algorithm that estimates by itself the system parameters from a data frame or a data movie can also be evaluated and benchmarked. 

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
|:-------|:------|:--------|:-----|
|UGIA-M     |Yi Sun | Electrical Engineering Department, The City College of New York |USA |
|UGIA-F     |Yi Sun | Electrical Engineering Department, The City College of New York |USA |
|[3D-DAOSTORM]( https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_ZhuangLab_storm-2Danalysis&d=DwID-g&c=4NmamNZG3KTnUCoC6InoLJ6KV1tbVKrkZXHRwtIMGmo&r=j0A6IFQM1sqhJ9JGnpoeSyUsEY4C_j3vAHGUhAHkwqc&m=KyWuibdcanyti6L5Rv5wyAfNPjtPqLpgLow4D7Hfwv0&s=D8QCk3zeetHK2OJqex-T45UyU0qNm8qUSdmB7HeK_gc&e=)|Hazen Babcock |Harvard Center for Advanced Imaging |USA |
|[Cspline]( https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_ZhuangLab_storm-2Danalysis&d=DwID-g&c=4NmamNZG3KTnUCoC6InoLJ6KV1tbVKrkZXHRwtIMGmo&r=j0A6IFQM1sqhJ9JGnpoeSyUsEY4C_j3vAHGUhAHkwqc&m=KyWuibdcanyti6L5Rv5wyAfNPjtPqLpgLow4D7Hfwv0&s=D8QCk3zeetHK2OJqex-T45UyU0qNm8qUSdmB7HeK_gc&e=)|Hazen Babcock |Harvard Center for Advanced Imaging |USA |
|[FCEG]( https://www.frontiersin.org/articles/10.3389/fbioe.2019.00338/full) |Fabian Hauser |University of Applied Sciences Upper Austria, School of Medical Engineering and Applied Social Sciences |Austria |
|[LSTR]( https://www.mdpi.com/1422-0067/19/4/1150) |Fabian Hauser |University of Applied Sciences Upper Austria, School of Medical Engineering and Applied Social Sciences |Austria |
|[PeakFit]( https://gdsc-smlm.readthedocs.io/en/latest) |Alex Herbert |Genome Damage and Stability Centre, University of Sussex |UK |
|SIC      |Yi Sun | Electrical Engineering Department, The City College of New York |USA |

# Matlab Codes
The data movies, data frames, UGIA-F estimator, and UGIA-M estimator all are generated and simulated by Matlab codes. The codes for a particular evaluation and benchmark are included in the corresponding subfolder, e.g. 2DGauss_ MEMF/Codes. The functions that are called by these codes are included in the folder /MyMatlab. 

# Reference and Citation
[1] Y. Sun, "Localization precision of stochastic optical localization nanoscopy using single frames," J. Biomed. Optics, vol. 18, no. 11, pp. 111418-14, Oct. 2013.

[2] Y. Sun, "Root mean square minimum distance as a quality metric for stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, no. 1, pp. 17211, Nov. 2018.

[3] Y. Sun, "[Spatiotemporal resolution as an information theoretical property of stochastic optical localization nanoscopy](https://www.researchgate.net/publication/335798848_Spatiotemporal_Resolution_as_an_Information_Theoretical_Property_of_Stochastic_Optical_Localization_Nanoscopy)," 2020 Quantitative BioImaging Conf., QBI 2020, Oxford, UK, Jan. 6-9, 2020. 

# Contact

Yi Sun, Electrical Engineering Department, Nanoscopy Laboratory, The City College of City University of New York, New York, NY 10031, USA. E-mail: ysun@ccny.cuny.edu
