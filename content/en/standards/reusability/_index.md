---
title: Reusability
linkTitle: Reusability
cascade:
  github_issue_filter: "label:\"standards -  reusability\""
  github_issue_template: reusability.md
  github_discuss_category: "reusability-standards"
weight: 2
---

{{% standards-preamble %}}
These standards are designed to facilitate reuse of model code which in principle supports reproducibility claims and verification of model results.
{{% /standards-preamble %}}

## Overview of Reusability Standards

In this document we adopt the <em>reuse</em> terminology defined in the [FAIR Principles for Research Software](https://www.rd-alliance.org/group/fair-research-software-fair4rs-wg/outcomes/fair-principles-research-software-fair4rs). 

> Reusability implicitly includes usability and focuses on the ability of humans and machines to execute, inspect, and understand the software so that it can be modified, built upon, or incorporated into other software.

## Goals for Reusability Standards

> A <em>reusable</em> computational model can be <b>executed, understood, modified, built upon, or incorporated</b> into other software. 

## Minimal Reusability Standards 

A minimal set of guidelines that can be adopted by journals to ensure that submitted publications meet baseline reproducibility and reusability requirements. 

Reusable computational models must:

- meet OMF minimal standards for <a href='{{< relref "/standards/accessibility" >}}'>Accessibility</a> and <a href='{{< relref "/standards/documentation" >}}'>Documentation</a>
- have a clear and accessible [open source, OSI approved license](https://choosealicense.com/)
- include detailed metadata that facilitate reuse (e.g., input and output semantics, data types, units)
- include detailed provenance on authorship and contributions
- provide qualified information on all software and system dependencies with versions (operating system, software and system libraries)
- provide clear instructions on how to execute the software

## Ideal Reusability Standards

In order to meet the ideal standards, computational models should:

- favor open file formats for data inputs and outputs (e.g., CSV, netCDF, geoJSON, Parquet, Feather)
- provide durable containerization recipes (i.e., archival quality container images)
- include relevant output analyses, data pipelines, and/or workflows
- include metadata on related research outputs (publications, other software, relationship)
- use continuous integration services that run automated tests on the software
- for software with large compute or data requirements, representative input data samples along with sampling methodology
- provide additional community established domain specific standards

## Cyberinfrastructure and Tools to Support Reusability Standards

Build Docker images from research code:
- stencila/dockta https://github.com/stencila/dockta
- ReproZip https://www.reprozip.org/
- SciUnit https://github.com/scidash/sciunit
- binder https://mybinder.org/
- repo2docker https://repo2docker.readthedocs.io (used by binder)

Computational Archives:
- [Whole Tale](https://wholetale.org/)
- [Code Ocean](https://codeocean.com/)

OMF may consider developing scaffolding for common modeling frameworks that reduce friction of adoption
  - examples: https://github.com/uwescience/shablona and https://github.com/geodynamics/software_template
  - GitHub bot that can help improve compliance with minimal / ideal standards
  - cookiecutter project structure that supports best practices for reproducibility and reusability (e.g., [Cookiecutter Data Science](http://drivendata.github.io/cookiecutter-data-science/))

## Examples and References

- [Lorena Barba's reproducible workflow for computational fluid dynamics](https://doi.org/10.5281/zenodo.2642710) https://github.com/barbagroup/cloud-repro 
- https://carpentries-incubator.github.io/good-enough-practices/
- http://www.practicereproducibleresearch.org/
- [Software Deposit Guidelines from SSI](https://softwaresaved.github.io/software-deposit-guidance/HowToDescribeSoftwareDeposit.html)
- [Proposed Standards for Peer-Reviewed Publication of Computer Code](https://doi.org/10.2134/agronj2015.0481)
- TODO: find or build example codebases that meet minimal and ideal standards 

## Issues / Errata

Dependencies on commercial / closed source products are fine so long as they are clearly qualified with version and operating system e.g., MATLAB R2016b (Windows 10), AnyLogic 8.7 (Windows 10), ArcGIS 10.8.1 (macOS 10.15), NetLogo 6.2.1 (Ubuntu 20.04LTS)
