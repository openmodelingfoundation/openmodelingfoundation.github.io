---
title: Interoperability
linkTitle: Interoperability
cascade:
  type: interoperability
  github_issue_filter: "label:\"standards - interoperability\""
  github_issue_template: interoperability.md
weight: 2
---

{{% standards-preamble %}}
These standards promote interoperability between models.
{{% /standards-preamble %}}

## Overview of Interoperability Standards

Interoperability standards aim to enable models, developed by a diverse scientific community, to be integrated into multi-component modeling environments to represent dynamics and interactions in complex social-natural systems at multiple scales. Standardized APIs and common ontologies, supplementing comprehensive documentation, are essential factors for achieving interoperability. Hence, the goals of interoperability standards include API compatibility and common ontologies so that models can be more readily interconnected as components in an open model ecosystem. There may be multiple implementation technologies to meet these standards.  

Questions for Assessing Interoperability 
- Can the model connect with another model (spatial and temporal synchronization)? 
- Does the model confirm to a standard API (application programming interface)?
- Are the input and output variables described using a common vocabulary? 
- Are the data types of input and output variables compatible?

## Goals for Interoperability Standards

OMF Interoperability standards should have the effect of increasing productivity by simplifying a variety of modeling tasks. Tasks that standards should facilitate should include (but are not necessarily limited to):
- Building a coupled model from process-oriented software components (models or model elements)
- Building "system of systems" models by assembling sub-models of particular systems (for example, a "lake system" model integrated with a "watershed system")
- Operating models/components in multiple different frameworks
- Operating models and data inputs/outputs efficiently as part of a sequence of tasks (approach: use/encourage file formats that are both standardized and open)
- Swapping input data sources (for example, comparing behavior of a model with two different satellite-based inputs of land cover, as opposed to having the model hard-wired to one particular source)
- Controlling parameter values and behavior without recompiling
- Operating a model on multiple platforms
- Retrieving information about a model's current state (including state variables) (implementation question: direct memory exchange vs. file-based exchange vs. web API)
- Pausing and continuing model execution
- Adjusting model variables and/or control parameters during a run (for example, to support data assimilation)
- Computing derivatives where applicable, to facilitate operations such as sensitivity analysis, optimization, and inference (note: different views among participants about whether this should be included in a standard, a "best practice" guideline, or not at all)
- Metadata and documentation related to interoperability
  - Clarity and precision in definitions of parameters and variables (ontology)
  - Data items to include in metadata: scale (space and time), typical run time, limits (e.g., range of calibration data)

## Minimal Interoperability Standards

## Ideal Interoperability Standards

## Cyberinfrastructure and Tools for Implementation of Interoperability Standards

### Cyberinfrastructure and Tools Needed

- Tool(s) to automatically test a program's adherence to standards

## Examples and References for Interoperability

