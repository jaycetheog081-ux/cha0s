<div align="center">

# cha0s

### An experimental iOS system research toolkit.

**Explore. Understand. Experiment.**

A modular toolkit exploring iOS system capabilities, security research,
device diagnostics, and customization.

[![Platform](https://img.shields.io/badge/Platform-iOS%2027-7B68EE?style=flat-square)](#compatibility)
[![Language](https://img.shields.io/badge/Language-Objective--C-438EFF?style=flat-square)](#technology)
[![Build](https://img.shields.io/badge/Build-GitHub%20Actions-2088FF?style=flat-square)](#building)
[![Status](https://img.shields.io/badge/Status-Experimental-orange?style=flat-square)](#project-status)

</div>

---

## About

**cha0s** is an experimental iOS toolkit focused on investigating system
capabilities, exploring accessible files, collecting diagnostics, and
researching potential methods of extending what is possible on iOS.

cha0s is an independent project. It is not a fork of Lara or another toolkit.

### Project goals

- Provide a clear overview of device and operating system information.
- Explore files and resources available to the application.
- Investigate iOS security vulnerabilities and their documented capabilities.
- Build a modular foundation for future system-access research.
- Provide useful diagnostics for developers and community testers.
- Distribute experimental builds through GitHub Releases.

## Features

### Dashboard
A central overview of the device, operating system, toolkit status,
and available capabilities.

### System Explorer
Browse accessible directories and inspect system information permitted
by the application's current privileges.

### Capability Engine
Check which operations are available and distinguish ordinary application
permissions from capabilities requiring additional privileges.

### Research Modules
A modular framework for investigating security vulnerabilities and
evaluating device and operating system compatibility.

### Diagnostics
Display errors, compatibility information, and sanitized diagnostic reports
to help developers and testers investigate problems.

### Customization
A foundation for exploring system customization where supported by the
device, operating system, and available privileges.

> Features are developed incrementally. Planned capabilities are not
> necessarily available in current releases.

## Interface

The cha0s interface takes inspiration from three notable jailbreak tools:

| Project | Design influence |
|---|---|
| Taurine | Clean layouts and cohesive visual styling |
| Chimera | Distinctive identity and straightforward navigation |
| Amethyst | Modern presentation and utility-focused design |

These influences guide the visual direction without reproducing their
interfaces wholesale.

cha0s will have its own branding, layout, and implementation.

## Compatibility

### Target platform

- **Operating system:** iOS 27
- **Development language:** Objective-C
- **Build environment:** GitHub Actions with a macOS runner
- **Distribution:** GitHub Releases

Compatibility with individual devices and iOS builds must be verified
through testing.

An application's ability to run on a particular iOS version does not
mean it automatically has elevated system privileges or can exploit
a vulnerability.

See the release notes for the compatibility information associated
with each build.

## Building

cha0s uses GitHub Actions to automate its build process.

The intended workflow is:

1. Retrieve the source code from the repository.
2. Configure the required Apple development tools.
3. Compile the Objective-C application.
4. Package the application for distribution.
5. Publish the build artifact for testing.

Signing and installation requirements depend on the distribution method
and the certificates available to the developer.

Build instructions and workflow configuration will be maintained in
the repository as development progresses.

## Security Research

Security research is an important part of cha0s.

The project may investigate publicly documented vulnerabilities affecting
iOS, including their affected versions, security boundaries, and potential
research applications.

A vulnerability's existence does not establish that it can be combined
with other vulnerabilities to create a working exploit chain.

Research modules must distinguish between:

- Documented vulnerabilities.
- Theoretical exploit possibilities.
- Experimentally verified capabilities.
- Features implemented and tested in cha0s.

No vulnerability will be described as a working exploit without supporting
technical evidence.

## Project Status

**cha0s is experimental and under active development.**

The initial development priorities are:

- [ ] Establish the application structure.
- [ ] Implement the main dashboard.
- [ ] Add device and operating system detection.
- [ ] Implement capability reporting.
- [ ] Create the system explorer.
- [ ] Add the research module framework.
- [ ] Implement diagnostics.
- [ ] Configure automated GitHub Actions builds.
- [ ] Publish the first experimental release.
- [ ] Establish a community testing process.

Items on this list represent development goals, not completed features.

## Community Testing

Community testing will help establish compatibility, identify bugs,
and improve the toolkit.

When testing a release:

1. Read the release notes before installation.
2. Confirm that your device and operating system are compatible.
3. Report reproducible problems with relevant diagnostic information.
4. Avoid sharing personal information, private files, or device secrets.
5. Report security-sensitive findings privately when appropriate.

Experimental builds may contain bugs and should not be assumed to be
safe for use on a primary device.

## Reporting Issues

When opening an issue, include:

- cha0s version.
- Device model.
- iOS version and build number.
- A description of the problem.
- Steps to reproduce the issue.
- Relevant sanitized logs or screenshots, if applicable.

Do not include passwords, signing credentials, private keys, or other
sensitive information in public issues.

Use GitHub Issues for reproducible bugs and feature requests.

## Contributing

Contributions, technical discussion, testing, and documentation improvements
are welcome.

Before submitting a contribution:

1. Describe the problem or improvement.
2. Keep changes focused and reproducible.
3. Document compatibility requirements.
4. Include testing information where available.
5. Distinguish verified behavior from assumptions.

Security-sensitive vulnerabilities should not be disclosed publicly
before appropriate coordination.

## Disclaimer

cha0s is an independent experimental software project intended for
research, development, and educational purposes.

It is not affiliated with or endorsed by Apple, Taurine, Chimera,
Amethyst, Lara, or other toolkits or jailbreaks.

The project does not guarantee compatibility with any particular device
or operating system build.

Users are responsible for understanding the risks associated with
experimental software and for complying with applicable laws.

## License

The project license will be specified in the repository.

Until a license is added, permission to reuse, modify, or redistribute
the project's code should not be assumed.

---

<div align="center">

**cha0s**

*Explore the system. Discover the possibilities.*

</div>
