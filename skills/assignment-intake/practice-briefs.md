# Practice briefs

Use these when there is no real brief yet, to practise and to test the skills. They are written in our own words, based on public descriptions of real interview exercises. Treat every number not given here as something you must assume.

---

## P1 — Move an on-premise CRM to the cloud

Source of the format: Yardstick, "Effective Work Sample Exercises for Hiring Top Solutions Architects" (https://yardstick.team/work-samples/effective-work-sample-exercises-for-hiring-top-solutions-architects).

A mid-size insurance company runs its customer relationship management (CRM) system in its own data centre. The system is 12 years old, customised heavily, and connected to a policy administration system, a billing system and a document archive. All three stay on-premise for at least three more years.

The company wants to move customer management to the cloud within 18 months. The budget is limited. Customer data falls under GDPR. The call centre (300 agents) must not lose service during the move.

**Your task:** propose a target architecture and a migration approach. Show how the cloud CRM will work with the systems that stay on-premise. Explain the main risks and how you would reduce them.

**Hand in:** a document. You will present it to a panel and answer questions.

---

## P2 — Secure credit card platform

Source of the case: "Presenting and analysing a case as a software-architect" (https://alfrepo.github.io/blog/notes/article000017).

A financial institution wants a new platform for credit cards: issuing cards, processing transactions with the card networks, detecting fraud, and billing and payments. It must follow PCI DSS, GDPR and CCPA. The four priorities are security, reliability, compliance and performance.

**Your task:** describe the architecture. Cover access control, the card lifecycle and credit limits, transaction processing, fraud detection, billing, non-functional requirements, the technology approach and testing. Explain why you made each main choice.

**Hand in:** a document and a presentation.

---

## P3 — Choose an integration approach

Source of the format: Yardstick (same page as P1), "Technical Solution Evaluation".

A retail group has 40 applications that exchange data with nightly file transfers and some point-to-point APIs. Shops need stock levels that are less than 5 minutes old. The integration team has 4 people. Three approaches are on the table: (a) an integration platform with central mappings, (b) an event streaming platform, (c) better APIs with an API gateway, no central platform.

**Your task:** compare the three approaches and recommend one. Show your criteria and how you scored the options. Explain how you would introduce the chosen approach.

**Hand in:** a short recommendation document (2–4 pages) that you defend in a 30-minute session.
