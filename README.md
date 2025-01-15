# PACE Lecture Series Website

This repository hosts the source code and configurations for building and deploying the **PACE Lecture Series Website**, a platform to share resources, events, and insights for programming language enthusiasts, compiler designers, and the high-performance computing community.

## Purpose
The repository is designed to:
- Provide a central hub for **PACE Lecture Series** activities.
- Enable collaboration and community engagement.
- Host resources, videos, and updates for lectures, workshops, and events.
- Use AWS Amplify for seamless hosting and deployment.

---

## Repository Structure

Here is an overview of the folder structure:

```
root
├── cdk/               # AWS CDK files for infrastructure as code.
├── themes/            # Hugo themes (Mainroad theme from Vimux).
├── content/           # Markdown content for the website.
├── static/            # Static assets (images, CSS, JS).
├── layouts/           # Custom Hugo layouts for the website.
├── config.toml        # Hugo configuration file.
└── README.md          # Documentation for this repository.
```

---

## What AWS CDK Does

The **AWS Cloud Development Kit (CDK)** is used to define and provision infrastructure for the website. Specifically, CDK enables:
- **Scalable Hosting**: Automatically deploy the website to AWS Amplify.
- **Resource Management**: Manage backend resources like a lightweight web server for server-side functionality.
- **Version Control Integration**: Connect the Amplify app to this GitHub repository for automated CI/CD.

---

## What the Hugo Theme Does

The **Mainroad theme from Vimux** is a clean and lightweight Hugo theme that:
- Provides a professional and responsive layout.
- Makes it easy to present lecture series content.
- Supports customization for branding and structure.

---

## CI/CD Pipeline

This repository is configured for **Continuous Integration and Continuous Deployment (CI/CD)** using AWS Amplify:
- **Branch Protection**: Only approved changes can be merged into the `main` branch.
- **Automated Deployment**: Once changes are merged into `main`, AWS Amplify automatically builds and deploys the website.

### Steps to Test Changes Locally
To ensure changes are correct before merging:
1. Clone the repository locally.
2. Install Hugo:
   ```bash
   brew install hugo
   ```
3. Run the website locally:
   ```bash
   hugo server
   ```
   Visit `http://localhost:1313` to view the site.
4. Test AWS CDK:
   ```bash
   cd cdk
   cdk synth
   cdk deploy
   ```
   Ensure infrastructure updates work as expected.
5. Once satisfied, open a Pull Request (PR).

---

## Commit Message Guidelines

To maintain consistency and traceability in commit history, follow this commit message convention:

**Commit Message Format**:
```
<type>: <description>
```

**Valid Types**:
- `DEV:` for development changes.
- `INFO:` for information updates or announcements.
- `MEET:` for meeting or event-related updates.
- `DOC:` for documentation updates.

Any commit not matching this regex will be rejected: `^(DEV|INFO|MEET|DOC): .+`

---

## Getting Started

### Hugo Help
- [Hugo Official Documentation](https://gohugo.io/documentation/)
- [Mainroad Theme Documentation](https://github.com/Vimux/Mainroad)

### AWS CDK Help
- [AWS CDK Documentation](https://docs.aws.amazon.com/cdk/latest/guide/home.html)
- [Getting Started with CDK](https://docs.aws.amazon.com/cdk/latest/guide/work-with.html)

---

## Questions or Support
For any issues or questions, feel free to open an issue in this repository or reach out to the maintainers.
