---
title: Documentation
linkTitle: Documentation
cascade:
  type: documentation
  github_issue_filter: "label:\"standards - documentation\""
  github_issue_template: documentation.md
weight: 2
---

<div class="alert alert-warning">
These standards promote documentation needed for others to understand a model and reproduce its results. Comments and suggestions are welcomed, and will be carefully considered by the OMF Working Groups and Membership. The standards goals and  minimum implementation standards aim to capture concerns and practices among the members of OMF. Individual application domains may extend these standards to capture additional context relevant to their domain.
</div>

Documentation of a model, together with the provided model code, needs to facilitate the understanding of the intentions of the developer, and make the model easier to test, use, and link to other models. It should also describe assumptions made about phenomena being modeled and what information is used to create and test the model.  
### Minimally, model documentation should include:
- Name and version of the model
- Description of the model, including its purpose or goals and the type or formalism of the model  (e.g., system dynamic, agent based model, machine learning), preferably accompanied by relevant keywords
- Name(s) and contact information of the developer(s)/author(s)
- Date of release
- License
- Location where the model is posted or published (e.g. URL or DOI)
- Computer language or platform used for programming
- Any other software and/or hardware requirements needed to run the model and replicate any published results
- Any data dependencies needed to run the model  and replicate any published results
- Information on how to install the model so that it can be run (e.g., compiling if needed)
- Any references to reports or publications where the model is used.

### For better understanding and reproducibility, documentation should also include: 
#### Processes and scales
- Assumptions: What are the key assumptions made that define the dynamics of the model?
- Model structure: provide a flow diagram of the model.
- Equations: What are the equations of the model?
- Temporal resolution, time stepping, and units (astronomical, biological, states, etc.)  
- Spatial dimensionality, resolution, extent, grid type if relevant  
#### Input/Output and Variables (specifying units as appropriate)
- Key input parameters and their values and domain ranges  
- Initial conditions:.  
- Forcing functions that affect the dynamics of the model.  
- Control variables  
- Key output variables and domain ranges  
#### Associated data sets
- Provide data used for calibration of the model and describe how calibration was performed. (If data cannot be shared due to embargos provide a synthetic data set in order to run the model).
#### Model validation, uncertainty, and sensitivity
- Describe any tests to verify the accuracy of the model
- Provide data used for validation of the model and describe how validation was performed.
- Provide sample runs that illustrate the dynamics of the model.
#### Update information
- New features since last version (if the model is an update)  




