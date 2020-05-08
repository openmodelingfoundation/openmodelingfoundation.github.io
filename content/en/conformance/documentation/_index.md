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
The standards below aim to be minimum standards for best practices in computational modeling. We focus on <i>minimum standards</i>  to reach a high level of adoption which will improve the quality of documentation a lot across the field. For purposes of this document, the word 'model' is shorthand for 'computational model program': a computer code that generates a numerical solution to one or more mathematical or algorithmic models of a natural and/or human system. 
This is a living document and comments are welcomed and will be addressed by the OMF standards committee. The minimum standards aim to capture concerns and practices among the members of OMF. Individual application domains could design adjusted and enhanced standards that capture specifics of that application domain. 
</div>

Documentation of a model, together with the provided model code, needs to facilitate the understanding of the intentions of the developer, and make the model easier to test, use, and link to other models. What are the assumptions made and what information is used to create and test the model? The following items are requested for a model description:

### Preliminaries
Name and version of the model
Name(s) of the developer(s)
Contact information developer(s)
Year of release
License type
Availability (DOI or URL)
Language/Package used (programming)
Computer requirements or mentioning which computer platform was used for testing
Software requirements (operating system, parallel, serial, etc.)
Information on how to install, and compile the model

Description of data dependencies (required input data, GIS, etc)

Description of software dependencies (which software need to be installed)

New features since last version (if the model is an update)

### General features
Purpose - what was the model built for
Model type - System Dynamics, Agent-Based Modeling, Artificial Neural Networks, conceptual, etc.
Scales
	Time - resolution, time stepping (astronomical, biological, states, etc.)
	Space - dimensionality, resolution, extent, grid type

### Processes
Assumptions: What are the key assumptions made that define the dynamics of the model?
Model structure: provide a flow diagram of the model.
Equations: What are the equations of the model?

### Input (units)
Parameters: Description of key parameters and their values (plus domain ranges)
Initial conditions: Description of the initial conditions of the model.
Forcing functions: What are, if any, forcings in the model that affect the dynamics of the model.
Control variables. What are, if any, control variables of the model.

### Variables, Output (units)
Describe the key variables and outputs (and domain ranges) of the model.

### Model characterization (accuracy, tests)
What has been done to verify the accuracy of the model? Are there any tests performed to verify accurate implementation?

### Data
Provide data used for calibration of the model and describe how calibration was performed. (If data cannot be shared due to embargos provide a synthetic data set in order to run the model).
Provide data used for validation of the model and describe how validation was performed.

### Sample runs
Provide some sample runs to describe the spatial and temporal dynamics of the model.

### Publications
Any references to reports or publications where the model is used.


