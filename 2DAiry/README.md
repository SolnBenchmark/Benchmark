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

**2DAiry_MEMF_LTR (multiple emitters multiple frames low temporal resolution, 10 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |2.58 |2.79 |2.65 |2.67|
|UGIA-F   |9.28 |9.57 |12.69 |10.51|
|SIC      |46.11 |46.28 |44.61 |45.67|

**2DAiry_MEMF_MTR (multiple emitters multiple frames median temporal resolution, 5 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |2.77 |2.77 |3.06 |2.87 |
|UGIA-F   |10.49 |12.70 |18.14 |13.78 |
|SIC      |46.39 |46.99 |47.17 |46.85 |

**2DAiry_MEMF_HTR (multiple emitters multiple frames high temporal resolution, 1 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |3.10 |3.32 |3.59 |3.34| 
|SIC      |51.27 |52.57 |51.82 |51.89| 
|UGIA-F   |36.80 |61.19 |108.90 |68.96|

**2DAiry_MEMF_STR (multiple emitters multiple frames super temporal resolution, 0.1 sec): RMSMD (nm) vs emitter distance**

|Algorithm|40 (nm)|30 (nm)|20 (nm)|Average|
|--------:|------:|-----:|-----:|-----:|
|UGIA-M   |4.82  |6.88  |12.22 |7.97 |
|SIC      |52.39 |53.11 |52.37 |52.62 |
