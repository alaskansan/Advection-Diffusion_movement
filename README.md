# Advection-Diffusion movement model
Advection-Diffusion based model in R for upstream migration of Klamath Chinook salmon

## Working Files in this Repo

### Filename: 00_model_setup_date.R

#### Contents/Actions
setup working directory and create PLOTS directory, read in S3 data, create Dist matrix, define temp barrier value and create temp barrier matrix, define classes of movement rates

#### Needs these modifications

- [ ]

### Filename: 01_modelrun_date.R

#### Contents/Actions
Simply sources other scripts and runs them in order

#### Needs these modifications

- [ ] Reorganize the filenames
- [ ] change this filename once the scripts are ordered

### Filename: 02_select_simulation_variables_date.R

#### Contents/Actions
User input for number of days to simulate upstream migration, run size

Creates Nadults matrix and initilizes with zeroes

#### Needs these modifications

- [ ] Change this to "Year to Simulate" 
- [ ] Modify weekly.probs and daily.probs to vary with a new distribution each model run
- [ ] Remove user input for "Enter a total run size" and call a value from known model sizes


Emily Cowles thesis work 2017  esc17@txstate.edu
