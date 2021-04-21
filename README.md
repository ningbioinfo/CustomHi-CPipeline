# CustomHi-CPipeline
The custom Hi-C pipeline

This piepline is specifically built to run the custom analysis pipeline described in
Liu, N., Alinejad-Rokny, H., Breen, J. (2021). Landscape of statistically significant chromatin interaction profiles of cell lines and primary tissues in the human genome.

Help page:
usage: metaInit.py [-h] [--a A] [--csv CSV] [--out OUT]
                   [--sampleList SAMPLELIST]

Initiating script for metaHiC project.

optional arguments:
  -h, --help            show this help message and exit
  --a A                 study accession for the public HiC study.
  --csv CSV             the csv file that contain all the HiC sample info.
  --out OUT             output path.
  --sampleList SAMPLELIST
                        file contains sample name instead of using the --a
                        argument
