# SeuratImage


This repo is the source for an Apptainer image that can be deployed on COSMOS-SENS.

It has the Seurat eco system installed - meaning Seurat, Azimuth, Signac and others.
For a full list and also a detailed information on how these packages were installed please check out the definition file.

To load this module on COSMOS:

```
ml SeuratImage/1.0
```

Will start the Jupyter server. Please run this as an sbatch job!


