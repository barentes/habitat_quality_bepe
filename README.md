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

### 1. Literature Review Analysis (R)
Literature review analysis to substantiate the elaboration of threat table (input data in theInVEST model).
**Script: lit_review_analysis.r**

### 2. Priority areas for restoration (bodiversity) within property boundaries
Extraction of mean priority for each preperty. Values extracted from the map of priority areas for the implementation of Payment for Environmental Services (ongoing doctoral project (Process No. 2023/04497-9).
**Script: priority_areas_stats.js**

### 3. Land Use Predominance
Extract the land use predominance within a property using CAR shapefile and Mapbiomas land use (Collection 9) from 2023.
**Script: LULC_predominance.r**

### 4. Land Use Scenarios
Scripts for the spatialization of **conservative** and **feasible** land use scenarios related to the research objectives.
**Scripts:**
**- Conservative: conservative_secnario.r**
**- Feasible: feasible_scenario.r** (feasible25 and feasible50 scenarios use the same scirpt changing only the input data)

---

## 🎓 Acknowledgments
This research was financially supported by the **São Paulo Research Foundation (FAPESP)**. 
**Grant Number:2025/00039-1****

---
*Developed as part of a PhD Research Internship.*
