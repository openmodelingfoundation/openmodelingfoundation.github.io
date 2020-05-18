---
title: Documentation
linkTitle: Documentation
cascade:
  type: documentation
  github_issue_filter: "label:\"standards - documentation\""
  github_issue_template: documentation.md
weight: 2
---

{{% standards-preamble %}}
These standards promote documentation needed for others to understand a model and reproduce its results.
{{% /standards-preamble %}}

Documentation of a model, together with the provided model code, needs to facilitate the understanding of the intentions of the developer, and make the model easier to test, use, and link to other models. It should also describe assumptions made about phenomena being modeled and what information is used to create and test the model.

We suggest three main categories of documentation:
- Metadata (required)
- Methods and theoretical foundation (equations, algorithms, theoretical model description)
- Implementation (numerical solution)

### Metadata, minimal requirements for documentation:

- Name and version of the model
- Model project page (organizational website or repository, if available)
- Description of the model, including its purpose or goals and the type or formalism of the model  (e.g., system dynamic, agent based model, machine learning), preferably accompanied by relevant keywords
- Name(s) and contact information of the developer(s)/author(s)
- Date of release
- Open source License
- How to cite the software
- Location where the model is posted or published (e.g. PID or DOI)
- Computer language or platform used for programming
- All software and/or hardware requirements needed to run the model and replicate any published results
- All data dependencies needed to run the model and replicate any published results
- Information on how to install the model so that it can be run (e.g., compilation and/or execution instructions)
- References to reports or publications where the model is used

### For better understanding and reproducibility, documentation should also include:

#### Processes and scales

- Assumptions: What are the key assumptions made that define the dynamics of the model?
- Model structure: provide a flow diagram of the model.
- Equations: What are the equations of the model?
- Temporal resolution, time stepping, and units (astronomical, biological, states, etc.)  
- Spatial dimensionality, resolution, extent, grid type if relevant

#### Input/Output and Variables (specifying units as appropriate)

- Key input parameters and their values and domain ranges and units  
- Initial conditions  
- Forcing functions that affect the dynamics of the model.  
- Control variables  
- Key output variables and domain ranges

#### Associated data sets

- Provide data used for calibration of the model and describe how calibration was performed. (If data cannot be shared due to embargos provide a synthetic data set in order to run the model).

#### Model validation, uncertainty, and sensitivity

- Describe any tests to verify the accuracy of the model
- Provide data used for evaluation of the model and describe how evaluation was performed.
- Provide sample runs that illustrate the dynamics of the model.
- List of publications on evaluation, uncertainty 
- Benchmarks for validation in your framework

#### Update information

- Changes since the last version (if the model is an update) including bug fixes, new features, or other substantive modifications.




