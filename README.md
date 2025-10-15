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
This is to also mention that the theme and the design of the page has been referred from (ILUGC)[https://ilugc.in/]


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
If you think that the list is not exhaustive, please open an issue and we can expand on that.

---

## Getting Started

### Hugo Help
- [Hugo Official Documentation](https://gohugo.io/documentation/)
- [Mainroad Theme Documentation](https://github.com/Vimux/Mainroad)

### AWS CDK Help
- [AWS CDK Documentation](https://docs.aws.amazon.com/cdk/latest/guide/home.html)
- [Getting Started with CDK](https://docs.aws.amazon.com/cdk/latest/guide/work-with.html)



This guide walks you through contributing a new talk to the PACE Lecture Series website.

### 1. Fork and Clone the Repository

First, fork the repository to your GitHub account and then clone it locally:

```bash
git clone [https://github.com/](https://github.com/)<your-username>/pace-lecture-series.git
cd pace-lecture-series
````

### 2\. Install Submodules

Run the following command to initialize the required themes:

```bash
git submodule update --init --recursive
```

This ensures that the necessary submodules (themes) are downloaded. It also fixes [Issue \#2](https://github.com/durwasa-chakraborty/pace-lecture-series/issues/2).

### 3\. Create a New Talk Page

Use Hugo to create a new talk page:

```bash
hugo new talks/YYYY-Mmm-DD-talk-1.md
```

For example:

```bash
hugo new talks/2025-Aug-05-talk-1.md
```

This will generate a file at `content/talks/YYYY-Mmm-DD-talk-1.md` with a default front matter where `draft = true`.

**Remember to set draft = false once you’re ready to publish.**

### 4\. Follow the Standard Format

Each talk entry should follow this structure:

**Note:** Use the format **'YYYY Mmm DD :: Talk Title'** for the title.

This will be displayed on the site, so consistency is important.

### 5\. Preview the Site Locally

To preview draft and published content locally:

```bash
hugo server -D
```

To preview only published content:

```bash
hugo server
```

Then open your browser and navigate to:
`http://localhost:1313`

### 6\. Submit a Pull Request

Once you’re happy with the result, push your changes and create a Pull Request to the main repository.

### 7\. View Changes Live

This site uses CI/CD via AWS Amplify.

After your PR is merged, changes will automatically be deployed to:
`https://main.d1iq1oyjdrwqfn.amplifyapp.com/`

```
```
---




## Questions or Support
For any issues or questions, feel free to open an issue in this repository or reach out to the maintainers.
