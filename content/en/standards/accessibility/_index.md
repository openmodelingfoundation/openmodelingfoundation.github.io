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
- Human readable model source code should be openly accessible in archives which adhere to FORCE11 software citation principles and expose their metadata in open, interoperable formats.
- Model source code should have an appropriate OSI approved license.
- Authors of published model-based research should make model source code accessible.
- Funding agencies should require model source code developed in sponsored research to be acccessible and should discourage the use of inaccessible third-party code.
- Journals require new model source code to be accessible when it is the basis for published articles and should discourage use of inaccessible third-party code.
- Repositories curating model source code should make that code discoverable by humans and machine search algorithms.

## Minimal Accessibility Standards

Model code and documentation should be archived in a searchable, open access, trusted digital repository. A DOI, permanent URL or other permanent digital resource locator for accessing the model code must be provided that links to the specific version of the code used. The archive should adhere to FORCE11 software citation principles (https://www.force11.org/software-citation-principles) and expose their metadata in open, interoperable formats like schema.org or codemeta.

## Ideal Accessibility Standards

## Cyberinfrastructure and Tools for Implementation of Accessibility Standards

## Examples and References for Accessibility

- A list of trusted digital repositories can be found at https://www.comses.net/resources/trusted-digital-repositories/ [perhaps becoming part of OMF website?]
- OSI approved licenses can be found at https://opensource.org/licenses

## Issues / Errata

An open question is how to facilitate follow ups to archived versions, such as bug fixes.

Making model code and documentation available in a version control system’s repository such as github.com is not recommended as they do not have an explicit mission to serve as a permanent archive and there are no protections or mechanisms to guard against data removal. There is, however, an established workflow, e.g., from [GitHub to Zenodo](https://guides.github.com/activities/citable-code/), that ensures proper archival of a GitHub repository with permanent identifiers that resolve to the specific version of archived code.
