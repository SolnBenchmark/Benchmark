# SolnBenchmark
SolnBenchmark provides a means to evaluate and benchmark performance of localization algorithms for stochastic optical localization nanoscopy (SOLN). The metric of root mean square minimum distance (RMSMD) [2] evaluates the accuracy of a SOLN image. The unbiased Gaussian information-achieving (UGIA-F and UGIA-M) estimators [1]-[3] benchmark the performance of a participant algorithm. In this way, a participant algorithm challenges the performance bound of the Fisher information. 

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
|QC-STORM |14.66 |25.19 |215.86 |85.24|

**2DAiry_MESF (multiple emitters single frame): RMSMD (nm) vs emitter density**

| Algorithm |0.5 emt/um<sup>2</sup>|1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|4 emt/um<sup>2</sup>|8 emt/um<sup>2</sup>|Average|
|-------:|------:|--------:|-----:|-----:|-----:|-----:|
|UGIA-F   |8.91 |9.70 |13.48 |18.28 |24.85 |15.04|
|SIC      |50.58 |51.11 |53.96 |55.87 |61.37 |54.58|
|3D-DAOSTORM |104.03 |70.94 |69.78 |99.38 |103.17 |89.46|
|QC-STORM |132.53 |134.63 |119.05 |167.89 |328.11 |176.44|

**2DAiry_MEMF_LTR (multiple emitters multiple frames low temporal resolution, 10 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |2.56  |2.58  |2.77  |2.63|
|UGIA-F   |9.11  |10.31 |11.87 |10.43|
|SIC      |44.91 |47.56 |45.49 |45.99|
|QC-STORM |15.13 |12.24 |14.51 |13.96|

**2DAiry_MEMF_MTR (multiple emitters multiple frames median temporal resolution, 5 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |3.00 |2.70 |2.73 |2.81|
|QC-STORM |12.94 |12.71 |11.05 |12.23 |
|UGIA-F   |10.74 |15.38 |25.39 |17.17|
|SIC      |48.05 |45.78 |44.99 |46.27|

**2DAiry_MEMF_HTR (multiple emitters multiple frames high temporal resolution, 1 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |3.10  |3.02  |3.45 |3.19| 
|QC-STORM |13.90 |12.86 |14.50   |13.75|
|SIC      |47.80 |45.67 |46.46 |46.64| 
|UGIA-F   |43.37 |88.96 |191.08  |107.80|

**2DAiry_MEMF_VTR (multiple emitters multiple frames very high temporal resolution, 0.5 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |4.45 |3.81 |2.83 |3.70|
|QC-STORM |13.58 |16.59 |14.03   |14.73|
|SIC      |46.84 |46.45 |47.26 |46.85|
|UGIA-F   |25.13 |70.48 |172.39  |89.33|

**2DAiry_MEMF_STR (multiple emitters multiple frames super temporal resolution, 0.1 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |4.44 |5.18 |10.86 |6.82|
|QC-STORM |28.07 |27.68 |  28.28 |  28.01|
|SIC      |47.64 |47.48 |48.09 |47.74|
|UGIA-F   |157.18 |202.84 |369.39 |243.14|

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

**2DGauss_MEMF_LTR (multiple emitters multiple frames low temporal resolution, 10 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |3.26  |3.20  |3.32  |3.26| 
|UGIA-F   |10.60 |15.27 |14.02 |13.29| 
|SIC      |43.77 |44.00 |45.01 |44.26| 

**2DGauss_MEMF_MTR (multiple emitters multiple frames median temporal resolution, 5 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |3.19 | 3.36  |3.30  |3.28|   
|UGIA-F   |15.57 |18.42 |37.80 |23.93| 
|SIC      |41.72 |42.14 |42.70 |42.19| 

**2DGauss_MEMF_HTR (multiple emitters multiple frames high temporal resolution, 1 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |3.35  |3.64  |4.15    |3.71|      
|SIC      |44.06 |43.43 |45.60 |44.36|  
|UGIA-F   |55.46 |95.30 |217.64  |122.80| 

**2DGauss_MEMF_VTR (multiple emitters multiple frames very high temporal resolution, 0.5 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |4.25  |3.67  |2.92  |3.61|
|SIC      |44.96 |43.10 |44.35 |44.14|
|UGIA-F   |38.06 |95.97 |170.28  |101.44|

**2DGauss_MEMF_STR (multiple emitters multiple frames super temporal resolution, 0.1 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |5.35   | 6.48    |11.37   |7.73|
|SIC      |44.77 |44.29 |43.69 |44.25|
|UGIA-F   |184.48  |238.10  |346.25  |256.28|

## 3D Astigmatic

**3DAS_SESF (single emitter single frame): RMSMD (nm) vs SNR**

| Algorithm |High SNR |Medium SNR |Low SNR |Average|
|-------:|------:|--------:|-----:|-----:|
|UGIA-F   |11.80 |17.23 |30.30 |19.78 |

**3DAS_MESF (Multiple emitters single frame): RMSMD (nm) vs emitter density**

| Algorithm |0.1 emt/um<sup>2</sup>|0.3 emt/um<sup>2</sup>|0.5 emt/um<sup>2</sup>|1 emt/um<sup>2</sup>|2 emt/um<sup>2</sup>|3 emt/um<sup>2</sup>|Average|
|-------:|------:|--------:|-----:|-----:|-----:|-----:|-----:|
|UGIA-F   |16.90 |21.44 |22.51 |25.37 |42.85 |68.90 |33.00 |

**3DAS_MEMF_LTR (multiple emitters multiple frames low temporal resolution, 10 sec): RMSMD vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |1.77  |1.05  |4.34  |2.39|   
|UGIA-F    |32.95 |42.68 |64.00 |46.54| 

**3DAS_MEMF_MTR (multiple emitters multiple frames median temporal resolution, 5 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |1.64  |1.78  |2.91  |2.11|   
|UGIA-F    |50.57 |68.82 |97.21 |72.20| 

**3DAS_MEMF_HTR (multiple emitters multiple frames high temporal resolution, 1 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |8.88  |9.66    |11.95   |10.16| 
|UGIA-F    |180.61  |230.46  |284.44  |231.83| 

**3DAS_MEMF_VTR (multiple emitters multiple frames very high temporal resolution, 0.5 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |6.93    |6.73    |7.57    |7.08| 
|UGIA-F    |139.77  |182.91  |248.23  |190.30| 

**3DAS_MEMF_STR (multiple emitters multiple frames super temporal resolution, 0.1 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |29.44   |27.21       |35.33       |30.66| 

# Non-Blind Localization
This evaluation and benchmark is non-blind, that is, all the parameters of an optical system are known a priori, which are supposed to have been obtained through a calibration. Nevertheless, a blind localization algorithm that estimates by itself the system parameters from a data frame or a data movie can also be evaluated and benchmarked. 

# Method
A variety of data frames and data movies that simulate experiments are synthesized. 

A participant algorithm estimates emitter locations from a data frame or a data movie and generates a SOLN image consisting of a list of the estimated emitter locations. 

The participant submits the estimated SOLN image. 

The accuracy of a submitted SOLN image is evaluated by RMSMD in comparison with the true emitter locations. 

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
|[MaLiang]( http://bmp.hust.edu.cn/srm/Software.htm) |Tingwei Quan |Wuhan National Laboratory for Optoelectronics, Huazhong University of Science and Technology |China |
|[MrSE]( http://bmp.hust.edu.cn/srm/Software.htm) |Hongqiang Ma |Wuhan National Laboratory for Optoelectronics, Huazhong University of Science and Technology |China |
|[PALMER]( http://bmp.hust.edu.cn/srm/Software.htm) |Yina Wang |Wuhan National Laboratory for Optoelectronics, Huazhong University of Science and Technology |China |
|[PeakFit]( https://gdsc-smlm.readthedocs.io/en/latest) |Alex Herbert |Genome Damage and Stability Centre, University of Sussex |UK |
|[QC-STORM]( https://github.com/SRMLabHUST/QC-STORM) |Luchang Li |Wuhan National Laboratory for Optoelectronics, Huazhong University of Science and Technology |China |
|SIC      |Yi Sun | Electrical Engineering Department, The City College of New York |USA |

# Matlab Codes
The data movies, data frames, UGIA-F estimator, and UGIA-M estimator all are generated and simulated by Matlab codes. The codes for a particular evaluation and benchmark are included in the corresponding subfolder, e.g. 2DGauss_ MEMF/Codes. The functions that are called by these codes are included in the folder /MyMatlab. 

# Reference and Citation
[1] Y. Sun, "Localization precision of stochastic optical localization nanoscopy using single frames," J. Biomed. Optics, vol. 18, no. 11, pp. 111418-14, Oct. 2013.

[2] Y. Sun, "Root mean square minimum distance as a quality metric for stochastic optical localization nanoscopy images," Sci. Reports, vol. 8, no. 1, pp. 17211, Nov. 2018.

[3] Y. Sun, "[Spatiotemporal resolution as an information theoretical property of stochastic optical localization nanoscopy](https://www.researchgate.net/publication/335798848_Spatiotemporal_Resolution_as_an_Information_Theoretical_Property_of_Stochastic_Optical_Localization_Nanoscopy)," 2020 Quantitative BioImaging Conf., QBI 2020, Oxford, UK, Jan. 6-9, 2020. 

# Contact

Yi Sun, Electrical Engineering Department, Nanoscopy Laboratory, The City College of City University of New York, New York, NY 10031, USA. E-mail: ysun@ccny.cuny.edu
