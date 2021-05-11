---
title: "Accessibility"
linkTitle: "Accessibility"
cascade:
  type: accessibility
  github_issue_filter: "label:\"standards - accessibility\""
  github_issue_template: accessibility.md
  github_discuss_category: "accessibility-standards"
weight: 1
---

{{% standards-preamble %}}
These standards promote and enable discovery and access for model code, documentation, and metadata.
{{% /standards-preamble %}}

## Overview of Accessibility Standards

## Goals for Accessibility Standards

-	Humans can read the model source code
-	Machines can read the model source code
-	Models follow [FAIR standards for research software](https://fair-software.eu/) (ongoing work at https://www.rd-alliance.org/groups/fair-research-software-fair4rs-wg)
-	Models are available in findable, trusted digital repositories
-	Citations lead to the exact version of a model used in the citing publication
-	Models expose metadata publicly using interoperable standards

## Minimal Accessibility Standards

Model code and documentation should be archived in a searchable, open access, trusted digital repository. A DOI, permanent URL or other permanent digital resource locator for accessing the model code must be provided that links to the specific version of the code used. The archive should adhere to FORCE11 software citation principles (https://www.force11.org/software-citation-principles) and expose their metadata in open, interoperable formats like schema.org or codemeta.

## Ideal Accessibility Standards

-	sponsors require model source code to be made publicly available in a trusted digital repository
-	journals require model source code publicly available in a trusted digital repository
-	model source code uses build and packaging tools that facilitate accessibility (examples: [pipenv / pip / poetry in Python](https://packaging.python.org/guides/tool-recommendations/), [ant](https://ant.apache.org) / [maven](https://maven.apache.org) in Java, Makefiles)
-	model source code has a Dockerfile or other containerization support so it can be run on multiple platforms
	
## Cyberinfrastructure and Tools for Implementation of Accessibility Standards

Create a clear checklist for the OMF website and training purposes that facilitates good software development practices with transparency and openness from the start.

Example:

-	Can you run your model on another computer/operating system?
-	Is your model code readable to others e.g., clean code that is well structured with clear and self-documenting variable names, well-commented and documented procedures, algorithms, and assumptions
-	Does your archived model live in a digital repository that follows [FAIR principles for research software](https://fair-software.eu/) 
-	Can you run your model in 5 years (containerization helps but there are still open issues with dependencies on proprietary software)

## Examples and References for Accessibility

- An initial list of digital repositories for software can be found at https://www.comses.net/resources/trusted-digital-repositories/ [perhaps this will become part of the OMF website?]
- full list of OSI approved licenses at https://opensource.org/licenses and more useful guidance at https://choosealicense.com/
