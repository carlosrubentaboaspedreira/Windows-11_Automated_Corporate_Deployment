# Windows-11_Automated_Corporate_Deployment

Enterprise-grade Windows 11 automated deployment ecosystem built with MDT, AD, and PowerShell. Features zero-touch software installation, BitLocker encryption, LAPS, OS optimization, and real-time alerts via Microsoft Teams Webhooks.

## 📋 Project Overview
This repository contains the core configuration files, automation scripts, and logic rules for a **Zero-Touch Corporate Deployment** environment. Built entirely with native Microsoft tools, this architecture drastically reduces IT provisioning time, eliminates human error, and standardizes the workstation infrastructure.

*(El documento técnico completo del proyecto, con capturas y explicaciones paso a paso de la arquitectura, se encuentra en la carpeta `Documentation` en español).*

## 🚀 Key Features
* **Zero-Touch Provisioning:** Fully automated OS installation bypassing out-of-box experience (OOBE) prompts.
* **Silent Software Installation:** Unattended deployment of corporate applications (Office 365, VPNs, Security agents).
* **Active Directory Integration:** Automatic domain joining and Organizational Unit (OU) placement.
* **Advanced Security:** Automated BitLocker encryption with keys backed up to AD, and LAPS implementation for local admin password management.
* **OS Optimization:** Custom PowerShell scripts to debloat Windows 11 (removing bloatware and unnecessary telemetry) and apply corporate branding.
* **Real-time Monitoring:** Integration with Microsoft Teams via Webhooks to notify the IT department upon successful deployments.

## 🛠️ Technologies Used
* **Infrastructure:** Windows Server 2022, Hyper-V, Active Directory, DNS, DHCP.
* **Deployment:** Microsoft Deployment Toolkit (MDT), Windows Deployment Services (WDS), Windows PE, PXE Boot.
* **Automation & Scripting:** PowerShell, Batch, XML, INI configurations.

## 📂 Repository Structure
* `/Applications_and_Config`: Scripts and configuration files for unattended software deployment (e.g., Office 365 XML, FortiClient batch scripts, Silent Commands list).
* `/MDT_Rules`: Core MDT orchestration logic (`CustomSettings.ini` and `Bootstrap.ini`).
* `/Scripts_Automatizado`: PowerShell scripts for system debloating, custom lock screen branding, and Teams Webhook notifications.
* `/Documentation`: The full 105-page technical guide detailing the architecture, setup, and troubleshooting.
