# **PenguinMails Standard Operating Procedure (SOP)**

> **Status**: Current | **Last Updated**: October 28, 2025

---

## 1. **Purpose**

This SOP defines the standard processes for planning, communication, task management, and sprint execution at PenguinMails.

It ensures all team members follow a consistent workflow to improve productivity, accountability, and delivery quality.

## 2. **Tools & Platform**
* Jira – Task creation, sprint planning, progress tracking
* Discord – Team communication, quick discussions, and daily updates
* Google Docs/Sheets – Documentation, PRDs, and research outputs
* GitHub – Code collaboration and version control

## 3. **Communication Rules**
* All work-related discussions happen in Discord using defined channels.
* Avoid direct messages for project-related issues, keep discussions transparent.
* Tag teammates directly when a response is required.
* Maintain professionalism and clarity at all times.
* Sync meetings: Once per sprint (Planning \+ Demo)
* Async updates: Daily in the sprint channel.

## 4. **Task Management**

All tasks must include a clear title, description, acceptance criteria, labels, and assignee.

Status Workflow:

* Backlog – Idea or future task.
* Selected for Development – Approved for the current sprint.
* In Progress – Developer actively working on it.
* Ready for Testing – Implementation complete and pending validation.
* Blocked – Stuck due to dependencies or missing inputs.
* Done – Fully reviewed and accepted.

## 5. **Sprint Workflow**

Each sprint runs for 1–2 weeks, depending on scope.

Phases:

* Planning: Define sprint goals and prioritize tasks.
* Execution: Developers update Jira daily and communicate blockers.
* Demo: Product Owner and stakeholders review completed tasks.
* Retrospective: Discuss what went well and how to improve in the next sprint.

Completion Rule:

A task is considered done only if it meets acceptance criteria and has been verified by the Product Owner.

## 6. **Developers Responsibilities**
* Update progress daily in Jira.
* Report blockers early through Discord or directly in Jira.
* Keep PRs small and link them to relevant Jira tasks.
* Write short documentation for implemented features.

## 7. **Product Owner Responsibilities**
* Ensure backlog is groomed and prioritized before each sprint.
* Follow up on blockers and task progress.
* Maintain alignment between product goals and technical execution.
* Review, test, and validate completed work.

## 8. **Code & Infrastructure**
* All environments (staging, production,) must have clear documentation.
* Infrastructure scripts must be version-controlled in GitHub.
* Access permissions and credentials should be approved before use.
* Use secure practices when managing configuration or deployment keys.

## 9. **Compliance & Security**
* Follow security best practices for all integrations and APIs.
* Use secure credentials and enable 2FA on all project accounts.
* Do not share confidential or client data outside official channels.
* Ensure compliance with GDPR and applicable data privacy laws.

## 10. **Team Structure**

| Role | Responsibilities |
| ----- | ----- |
| Founders (Mustafa & Anthony) | Oversee product direction, business strategy, and technical vision. Approve sprint goals, review demos, and ensure alignment between product and market goals. |
| Product Owner (Rasak) | Maintains sprint structure, Jira board organization, and progress tracking. Acts as a bridge between founders and developers to ensure clarity and quality delivery. |
| Frontend Developer(s) | Implement UI/UX features, integrate APIs, and ensure frontend responsiveness and functionality. |
| Infrastructure Developer(s) | Handle server setup, automation, deployment pipelines, and scalability. Ensure reliable backend and email delivery infrastructure. |
| Designer(s) | Create product visuals, landing pages, and support UI consistency. |
| Interns/Assistants | Support planning, documentation, and follow-ups under PO guidance. |

## 11. **Reviews & Updates**

This SOP will be reviewed consistently by the Product Owner and core team.

Any updates or process changes will be communicated in the channel.

---

## Related Documents
- [Onboarding Guide](onboarding_guide.md) - Team member integration processes
- [Security Documentation](security_documentation.md) - Security procedures and protocols
- [Implementation Roadmap](implementation_roadmap.md) - Process improvement planning
- [Development Guidelines](development_guidelines.md) - Code standards and development practices