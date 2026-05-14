# ecephys spike sorting -- for NP2 Quad base data


## Overview
This was based on Jennifer's pipeline. The goal here is to sort NP2 quad base data, by treating each shank as a NP1.

## why I choose to split shanks instead of sorting the whole NP2 quad base all at once
- Each shank is seperated in a large distance, sorting shank by shank does not influence the final outcome.
- The time took to sort the whole NP2 quad base might take several days on a regular PC. i.e., the time does not increase linearly when increasing the channel number.

## what is different from Jennifer's pipeline
- Our lab requires Kilosort 2.5 to sort the data. As we relies on the feature output from Kilosort 2.5 to infer good/bad units based on our customized classifier. Kilosort 4.0 gives different feature metrics for units.
- The previous Jennifer's pipeline, specifically splitting shank one, has some issues related to the compatibility with the Kilosort 2.5
- The detailed modified code can be checked in the committed history.
- We need to add metrics about how drifting a unit is. So after sorting each shank, several matlab files were integrated to calcultae the drift metrics for each units. (Original file was written by Heet, Runbo, Nuo et al. in the lab)

## Installation and Usage for the SpikeGLX pipeline

### Download the newest version of Catgt 
 [CatGT](http://billkarsh.github.io/SpikeGLX/#catgt)

### Install ecephys environment and code

Clone (or download and unzip) this repo.

In the command window navigate to the ecephys_spike_sorting directory at the top level of the repo, e.g.:

cd \Users\labadmin\Documents\ecephys_clone\ecephys_spike_sorting

Build the environment -- it will use the Pipfile located in this directory, and create the virtual environment in the local directory. Currently (April 2024) the latest version of setuptools appears to not function with installation of MATLAB, so after the install, we activate the environment and use pip to uninstall setuptools and install 59.8.0.  Finally, install the ecephys code in the environment.

```shell
    $ set PIPENV_VENV_IN_PROJECT=1
    $ pipenv install
    $ pipenv shell
    (.venv) $ pip uninstall setuptools
    (.venv) $ pip install setuptools==59.8.0
    (.venv) $ pip install phylib
    (.venv) $ pip install .
```
### Set up to run MATLAB from Python

The python version and MATLAB version need to be compatible. For Python 3.8, this requires MATLAB 2020b or later. The code has been tested only with MATLAB 2021b.

Install MATLAB 2021b. Side by side installations of MATLAB are fine, so there is no need to delete earlier versions, and running code specific to an earlier version should be possible.

Open MATLAB 2021b, and enter the command gpuDevice(). You make get a message that there are no GPU devices with compatible drivers. Later versions of MATLAB also require more recent drivers for the GPU card. MATLAB 2021b requires version 10.1 or later of the Nvidia drivers. 

If you get that message, quit MATLAB. Update the drivers for the GPU card; this can be done with the Device Manager in Windows 10, and will also happen automatically if you update the CUDA Toolkit. The pipeline has been tested with CUDA Toolkit 11.2 (by the way, all CUDA toolkit versions are backward compatible to older hardware). After updating, restart MATLAB and enter gpuDevice() again to make sure it is recognized.

The MATLAB engine for python must be installed in the local instance of python run by the virtual environment. Open the command prompt as administrator, navigate to the ecephys directory, and enter:

```shell
$ pipenv shell
(.venv) $ cd <matlabroot>\extern\engines\python
(.venv) $ python setup.py install
```

Replace <matlabroot> with the root directory of your MATLAB 2021b installation, for example: 

C:\Program Files\MATLAB\R2021b

For more details about installing the python engine, see the MATAB documentation:

https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html

NOTE: This install needs to be repeated whenenver the virtual environment is rebuilt (e.g. after creating a new clone or download of the repo).

After completing the install, close the command window and reopen as a normal user (not administrator) to run scripts.

# Usage
### Storage management
As a session of NP2 quad base recording can be 600GB, It is better to assign a dedicated drive for the spike sorting.

### Edit parameters for your system and runs

Parameters are set in two files. Values that are constant across runs�like paths to code, parameters for sorting, etc � are set in **create_input_json.py**. Parameters that need to be set per run (run names, which triggers and probes to process�) are set in script files.

In **create_input_json.py**, be sure to set these paths and parameters for your system:

- ecephys_directory: parent directory that contains the modules directory
- kilosort_repository
- KS2ver -- needs to be set to '2.5' or '2.0', and be correct for the repository
- npy_matlab_repository
- catGTPath: contains the CatGT.exe file
- cWaves_path: contains the C_Waves.exe file
- tPrimePath: contains the TPrime.exe file
- kilosort_output_temp (see note below)

>>> Note: The kilosort_output_temp folder contains the kilosort residual file and also temporary copies of the config and master file. With kilosort 2.5, this "temporary" file--which has been drift corrected--may be used for manual curation in phy. If you want it to be kept available, set the parameter ks_copy_fproc=1; then a copy will be made with the kilosort output and the params.py adjusted automatically.

Other rarely changed parameters in **create_input_json.py**:

- Most Kilosort and pykilosort parameters. 
- kilosort post processing params 
- quality metrics params

Read through the parameter list for **create_input_json.py** to see which parameters are already passed in and therefore settable per run from a calling pipeline script. These currently include the threshold parameter for Kilosort, switches to include postprocessing steps within Kilosort, and radii (in um) to define the extent of templates and regions for calculating quality metrics. These radii are converted to sites in **create_input_json.py** using the probe type read from the metadata.


### Running scripts
please refer to `sglx_runlist_split_shanks_pipeline.py`.


## Terms of Use

See [Allen Institute Terms of Use](https://alleninstitute.org/legal/terms-use/)


© 2019 Allen Institute for Brain Science