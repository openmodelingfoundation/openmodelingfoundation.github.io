---
title: "Accessibility"
linkTitle: "Accessibility"
cascade:
  type: accessibility
  github_issue_filter: "label:\"standards - accessibility\""
  github_issue_template: accessibility.md
weight: 1
---

{{% standards-preamble %}}
These standards promote and enable discovery and access for model code, documentation, and metadata.
{{% /standards-preamble %}}

## Overview of Accessibility Standards

## Goals for Accessibility Standards
- access to source code and data of models so that models can be reused.
- define accessability for different stakeholder groups (peer modelers, students, decision makers)
- create simple to use and dissiminate check lists 
- reduce dependency of models on operating platforms.

## Minimal Accessibility Standards
-  Model code and documentation should be archived in a searchable, open access, trusted digital repository. A DOI, permanent URL or other permanent digital resource locator for accessing the model code must be provided that links to the specific version of the code used. The archive should adhere to FORCE11 software citation principles (https://www.force11.org/software-citation-principles) and expose their metadata in open, interoperable formats like schema.org or codemeta.
- Model source code should have an appropriate OSI approved license.

## Aspirational Accessibility Standards
- Funding agencies should require model source code developed in sponsored research to be acccessible and should discourage the use of inaccessible third-party code.
- Journals require new model source code to be accessible when it is the basis for published articles and should discourage use of inaccessible third-party code.
- There should be connections between archived model versions and reposities that are used for active model development and version control systems, so that people can find more recent model version.
- Increase access to easy to use containerization workflows and stimulate the archiving of containarized models

## Cyberinfrastructure and Tools for Implementation of Accessibility Standards

## Examples and References for Accessibility
- A list of trusted digital repositories can be found at https://www.comses.net/resources/trusted-digital-repositories/ [perhaps becoming part of OMF website?]
- OSI approved licenses can be found at https://opensource.org/licenses

## Issues 
Making model code and documentation available in a version control system’s repository such as github.com is not recommended as they do not have an explicit mission to serve as a permanent archive and there are no protections or mechanisms to guard against data removal. There is, however, an established workflow, e.g., from [GitHub to Zenodo](https://guides.github.com/activities/citable-code/), that ensures proper archival of a GitHub repository with permanent identifiers that resolve to the specific version of archived code.
