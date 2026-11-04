---
title: "OMF’s ODD protocol — Draft 1"
linkTitle: "Draft 1"
description: "Preserved review draft of the proposed documentation standard, with its definition and templates-and-examples supplement."
layout: standard
standard_revision: "Draft 1"
standard_stage: "Community review"
review_deadline: "2026-11-30"
# Set the source RFC URL when available.
rfc_url: ""
discussion_url: "https://github.com/openmodelingfoundation/rfcs/discussions/2"
weight: 2
type: docs
edition_id: "draft-1"
archived: true
standard_status: "Proposed standard · Not yet adopted"
announcement_date: "2026-11-02"
snapshot_date: "2026-11-03"
date: "2026-11-03"
current_page: "/standards/documentation"
---

## Review and feedback

The Standards Working Group has completed the draft of its proposed first OMF standard, **OMF’s ODD**, and invites comments, questions, and suggestions. **Please send feedback by Monday, November 30, 2026; earlier feedback is encouraged.** The proposal has not been adopted as an OMF standard.

[Join the GitHub Discussion](https://github.com/openmodelingfoundation/rfcs/discussions/2), or email [Volker Grimm](mailto:volker.grimm@ufz.de?subject=Comments%20and%20feedback%20on%20OMF%27s%20ODD) or the [OMF Administrative Coordinator](mailto:Charlotte.Till@asu.edu?subject=Comments%20and%20feedback%20on%20OMF%27s%20ODD). You may also request an in-person or virtual conversation; the working group will try to arrange individual or joint meetings to address questions.

### Review both documents

Please read **both the draft definition and its supplement** before submitting feedback. The supplement includes draft templates, a reference to the working group’s typology of standards, and examples of OMF ODD in use.

| Review document | Word | PDF |
| :--- | :--- | :--- |
| Draft definition of the standard | {{< standard-file "definition.docx" "Definition (Word)" >}} | {{< standard-file "definition.pdf" "Definition (PDF)" >}} |
| Templates and examples supplement | {{< standard-file "supplement.docx" "Supplement (Word)" >}} | {{< standard-file "supplement.pdf" "Supplement (PDF)" >}} |

If you cannot access these files, [contact the OMF Administrative Coordinator](mailto:Charlotte.Till@asu.edu?subject=OMF%20ODD%20review%20documents) to request copies.

### What happens after review

1. The working group will use community feedback, and input from journal editors where possible, to revise the proposal and supporting materials.
2. The OMF Executive Committee will check the final version again.
3. The full OMF Members Council will vote on the proposal in **2027**.

If approved, the standard will receive a DOI and an accompanying publication will be prepared to formally announce it. The announcement distinguishes peer review of that publication from the standard itself, which will already be fixed. The working group also hopes journal editors will introduce the standard and encourage or require its use, at least at the base level.

This review context comes from the [November 2, 2026 announcement](https://github.com/openmodelingfoundation/rfcs/discussions/2), signed by working group co-chairs **Volker Grimm, Serena Hamilton, Geerten Hengeveld, and Maria Pierce**, and the [OMF Executive Committee]({{< relref "/about/executive-committee" >}}).

### About this web edition

This review snapshot was captured on **November 3, 2026**, following the November 2 announcement. It preserves the files retrieved on the capture date, not a verified historical copy of their earlier contents. The Word and PDF originals are retained alongside the supplied Markdown transcription.

Download the {{< standard-file "manifest.json" "provenance and SHA-256 checksum record" >}}. The webpage’s typography and navigation may change with the site; the edition text and original files are preserved. No RFC number or DOI has been assigned to this snapshot.

The text below reproduces the supplied first draft, with its main structural table presented as sections for easier reading. Administrative placeholders and references remain as supplied; publication details have not yet been verified. The original draft is available above.

Earlier workshop material remains available as the [earlier documentation working draft]({{< relref "/working-groups/standards/drafts/documentation" >}}).

## Overview

Goals and intent of the standard  
**OMF’s ODD protocol is a standard format for describing models**. By introducing a common document structure and terminology, it provides a general language, or lingua franca, for modellers from all domains and for model clients and users. 

Executive summary  
**OMF’s ODD protocol is a standard for documenting models that are dynamic and mechanistic in the widest sense**. Its three purposes are: (1) provide a general non-technical language for communicating a model’s overall idea, purpose, and structure; (2) provide an overview of the rationale underlying the model’s design; (3) provide the details that are needed to fully understand and replicate the model. ODD is a tiered standard, where one or all three purposes are covered. 

History and background  
**The ODD protocol** was originally developed for describing agent-based models (ABMs, Grimm et al. 2006). It has been used for more than 4000 ABMs and **is one of the most widely used modelling standards**. The rationale of ODD has been used for other model types, for comparing models, and as a checklist  for supporting collaborative model development (Grimm et al. 2027)[^1].

## Administrative

OMF-Standard number: 1.0 \- Date: .. DOI: Owner/Authors: NN  
When making use of this standard, please cite as: … \[TBD\]

## Scope

OMF’s ODD protocol covers the following dimensions of modelling standards:

| Standard’s dimension1 | OMF’s ODD protocol |
| :---- | :---- |
| Type | Norm |
| Principles relevant to FAIR-aligned modelling | Interoperability (informational), Transparency |
| Function | Model transparency, Reusability of model |
| Model life cycle contribution | Model documentation |
| Stakeholders | All possible stakeholders |

1 from Rosello et al. (2026), see Supplement S.1

## Compliance

How can authors tell if they have complied with the standard?   
**OMF’s ODD protocol comes with a template** which introduces a document structure (Overview, Design concept, Details) and a certain terminology (e.g., entities, variables, processes, scheduling, design concepts). Using this terminology and the template is mandatory and can easily be checked. The glossary below makes sure that the terminology, which narrows down certain terms to a specific meaning, is used consistently. 

How can others tell?   
By using the template and the terminology/glossary as a checklist[^2]. 

## The standard’s definition {#the-standards-definition}

**OMF’s ODD protocol for standard model descriptions**

The ODD protocol comprises three parts: Overview, Design Concepts, and Details. The **Overview** provides an overview of the model’s purpose, questions, validation criteria, state variables, processes, and scales. The **Design Concepts** part lists important concepts underlying the model’s design; it is meant to make sure these concepts are addressed explicitly. The **Details** part includes information about the model’s initialization, input data representing external drivers, and the details of the submodels implementing the model’s processes.

ODD model descriptions include seven elements (Table 1, presented as sections below).

OMF’s ODD follows a tiered approach: 

At the **base level**, only the O part is provided, but the remaining model description explicitly refers to the entities, state variables, processes and scales of the O part, by using the same names for variables etc. 

At the **full level**, all three parts O, D, and D should be covered. Here, the O part follows the protocol, while for the two Details part, detailed instructions so far only exist for purely algorithmic models (agent-based, cellular automata-type models, etc.), while substandards for, e.g., purely equation-based models do not yet exist. Instead, the generic template of OMF’s ODD provides checklists, following the rationale of reporting guidelines in medical research[^3]. 

**Table 1**: This is the main structure of a full ODD model description, comprised of seven elements.

### Overview

The Overview part allows us to understand what the model is about and how it conceptualizes the system of interest, and it allows us to zoom into the details of its rationale and implementation. The Overview can, if too long for the main of a publication, go the the supplement and be represented by a narrative summary (Box 1).

#### 1. Purpose and patterns

Explains the overall aim of the model, the research questions it addresses, and the data or patterns observed in reality that are used to claim the model is realistic enough for its purpose.

#### 2. Entities, state variables, and scales

Describes the entities comprising the model world, their state variables or attributes, and the spatial and temporal scales of the model.

#### 3. Process overview and scheduling

Outlines the processes in the model and how they are scheduled within the model’s time step. They could be represented by a set of coupled equations, or by a sequence of submodels that are scheduled according to a certain algorithm.

### Design Concepts

They describe important concepts, methods or approaches that underlie the model’s design. The approaches could include the programming language, software, or numerical solvers being used. For agent-based models there are ten concepts, here we list only those of them which are likely to be relevant for most model types.

#### 4. Design concepts

- **Basic principles:** Describes the theoretical and empirical foundations underlying the model.
- **Stochasticity:** Explains the role of randomness in the model’s processes.
- **Observation:** Specifies what data are recorded from the model and how outputs are measured.

### Details

The Details part is about transparency and reproducibility, i.e. the technical part of the model descriptions. Here, all details that are needed to replicate the model are specified, and linked, via cross-references, the code implementing the model and related scripts.

#### 5. Initialization

Describes the initial definition of the model world, i.e. all entities present at the start and their state variables' settings.

#### 6. Input data

Specifies any external data used to drive the model during simulations.

#### 7. Submodels

Provides detailed descriptions of the rules and mechanisms governing changes of the model´s entities over time. Their names of variables and processes should correspond to the names used in the Overview part.

## Glossary

**Design concepts**: Concepts that underlie a model’s design. They are so important for a model’s scope and usefulness that their choice and use needs to be considered explicitly.   
*Comment*: They differ between model types. For agent-based models, emergence (emergent behavior), learning, or interaction are examples. For other model types, using a grid of spatial units, assuming rationale behaviour, or the settings of a numerical solution are possible examples.

**Entity**: An entity is a distinct object, organism, component, or unit of interest in the model that has an identity and may possess attributes and participate in processes or interactions.  
*Examples*: organisms, collectives of organisms (packs), people, institutions; spatial units (cells in models which use a grid of cells to represent spatial heterogeneity and interactions); the environment (weather, market price). 

**Initialization**: The initial setting of the number of all entities, and the initial value of all state variables of all entities. Per run, this happens only once, while the schedule of processes within a time step is repeated until a given stop condition is met. 

**Input Data**: Data of external drivers of the modelled system, which change over time, are imported from external files.  
	Examples: Weather, market price, etc.  
*Comment*: “Input” here refers to input from data files, not from users via the Graphical User Interface.

**Process**: A process is a mechanism or sequence of activities through which entities, their states, or relationships change over time. 

**Scales**: Spatial and temporal scales specify the spatial and temporal dimensions at which a model represents a system, its entities, and its processes.   
*Spatial extent*: The total area or geographical domain covered by the model.  
*Spatial resolution*: The size of the smallest spatial units distinguished by the model, or the precision with which locations are represented.  
*Temporal extent*: The total period covered by the model.  
*Temporal resolution*: The duration of the time steps or the smallest time intervals at which changes are represented.  
*Comment*: Note that large scale in geography is the opposite of large scale in ecology and other environmental sciences. 

**Scheduling**: The sequence by which a model’s processes are executed. The sequence of processes within the time step by which the model moves on matters and therefore needs to be carefully designed and fully communicated. The same holds for models with coupled ODEs or PDEs, where the solvers often do not solve all equations in one step, but one after the other. 

**State variable**: A variable or attribute that characterizes an entity.

*Examples*: age, group size (packs), bold vs shy personality; vegetation cover, soil moisture  
*Comment*: state variables are “elemental” in that they cannot be calculated from other state variables (biomass of a tree is a state variable, summed-up biomass of a forest is not). State variables allow to distinguish entities; they vary over time, or among entities, or both. Parameters, which are usually constant during a model run, can be state variables if they are, e.g. assigned stochastically to the entities during model initialization. 

**Submodels**: Implementation of the processes listed in the process overview of the Overview part of ODD.   
	*Comment*: This can be simple equations, complex algorithms, or a mix of both.

## Template and examples

See Supplement “OMFsODD Supplement \- Templates and Examples.docx”. 

The supplement linked in the review announcement is available in {{< standard-file "supplement.docx" "Word" >}} and {{< standard-file "supplement.pdf" "PDF" >}} formats. Please review it alongside the definition above.

## References

Grimm, V., Rosello, C., Hamilton, S., Gallagher, C., Micheletti, T., Szangolies, L., ... & Railsback, S. (2027). Twenty years of the ODD protocol: development, usage, extensions, and lessons learned about modelling standards development. Environmental Modelling & Software 207, 107203 

Rosello  C, Hamilton SH, Grimm V, Barton MC, Edmonds B, Elsawah S, Grant WE, Hengeveld GM, Jakeman AJ, Koralewski TE, Lynch I, Lemmen C, Pierce MEj, Qin C-Z, Vincenot CE, Wang H-H. 2026\. FAIR principles for good modeling practice and standards. SSRN 6213393\. DOI: 10.2139/ssrn.6213393 

[^1]:  Nov 1, 2026

[^2]:  LLM-based tools will help testing for compliance.

[^3]:  Reporting guidelines provide checklists where authors specify where in their article or report certain pieces of information are to be found, e.g. CONSORT for randomized trials in medical studies  (over 12,000 citations, see example in Supplemen S5).  


