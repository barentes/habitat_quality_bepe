# habitat_quality_bepe

# Ecosystem service scenarios through restoration for Payment for Ecosystem Services implementation
### BEPE FAPESP - Research Internship Abroad Fellowship (BEPE)

This repository contains the methodological procedures developed during a research internship at the **Queensland University of Technology (QUT)**, as part of my PhD studies at the **Federal University of São Carlos (UFSCAR)**. 

The work focused on the preparation of input data (threats and sensitivity tables) and the spatialization of land use scenarios to run the **Habitat Quality** model (InVEST software - Stanford University). The primary goal was to integrate habitat quality, as a proxy for biodiversity, parameters into payment for ecosystem services modeling.

---

## 👥 Research Team

* **PhD Candidate:** Barbara Rentes Barbosa
* **Supervisor (Brazil):** * Prof. Roberta Averna Valente (UFSCAR)
* **Supervisors (Abroad):** * Prof. Jonathan Rhodes (QUT); * Prof. Kaline de Mello (Charles Darwin University)

---

## 🛠 Workflow

The research followed the processing steps detailed below:

### 1. Pre-processing (Google Earth Engine)
Extraction of descriptive statistics and percentiles from the map of priority areas for the implementation of Payment for Environmental Services (PES) and opportunity cost maps. 
* **Status:** JavaScript codes are available in the `/scripts` folder.

### 2. Literature Review Analysis (R)
Literature review analysis to substantiate the elaboration of threat table (input data in theInVEST model).

### 3. Linear regression for sensibility table (R)
Linear regression to substantiate the elaboration of sensibility table (input data in theInVEST model).

### 4. Opportunity Cost (ArcGIS)
Development of the opportunity cost map using the Raster Calculator.

  * **Formula applied:** > $Opportunity Cost = (Land Price \times 0.5) + (Agricultural Suitability \times 0.5)$

### 5. Land Use Scenarios
Scripts for the spatialization of **conservative** and **feasible** scenarios related to the research objectives.

---

## 🎓 Acknowledgments
This research was financially supported by the **São Paulo Research Foundation (FAPESP)**. 
**Grant Number:**2023/04497-9

---
*Developed as part of a PhD Research Internship.*
