# Stata Collect Workshop

This repository contains code and data for a workshop on Stata's ```collect``` tablemaking suite for my ECON 1430 students.

## Data

The data for this workshop is a combination of Medicaid expansion data and American Community Survey data. The Medicaid expansion data contains years of expansion and rates of health insurance among low-income, childless adults. The American Community Survey data contains various individual-level covariates that I collapsed to the state x year level. ACS data (pre-collapsed) is in the replication package as *acs_data_collapse.dta*. Medicaid expansion data is *ehec_data.dta*. The data file I used to create tables in the workshop is *workshop_data.dta*.

## Code

There are two code files in this repository: *collect-workshop.do* and *collect-workshop-cleaning.do*. The former contains code creating a balance table and a regression table and exporting it to *.tex*. I walked students through the code line-by-line during the workshop. The cleaning file has code to create new covariates in the ACS data, collapse it to the state x year level, and merge with the Medicaid expansion data.