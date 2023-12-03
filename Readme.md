# TuxMagnet

TuxMagnet is a command-line utility that allows users to install applications on different operating systems (Arch Linux, Ubuntu, and Fedora). It presents a simple menu system where users can choose their desired operating system and then select applications to install.

## How to Run

To run this script on your local machine, follow these steps:

#### 1. Clone the repository:

```
  git clone https://github.com/kpndevroot/tuxmagnet.git $HOME/tuxmagnet && \
  echo 'alias tuxmagnet="$HOME/tuxmagnet/tuxmagnet.sh"' >> ~/.bashrc && \
  source ~/.bashrc && \
  chmod +x $HOME/tuxmagnet/tuxmagnet.sh
```



#### 2. Run the script using the `tuxmagnet` alias:

```
tuxmagnet
```
       


## Functionality

### System Update

The script asks if the user wants to update the system's package repository and upgrade the system. This is optional but recommended for accurate package installation.

### Operating System Selection

Users can choose their desired operating system from the provided options: Arch, Ubuntu, Fedora, or exit the script.

### Application Installation

After selecting the operating system, users can view a list of available applications for that specific OS. They can choose to install individual applications, all available applications, or go back to the OS selection menu.

### Displaying Installation Status

The script displays the installation status of each application for all supported operating systems.

## Vulnerabilities

The script has a few potential vulnerabilities:

**Application Installation:** The script assumes that the installation commands for each application are correct and safe. A malicious user could potentially manipulate the script to execute harmful commands.

**Input Validation:** While the script attempts to validate user inputs, there may still be cases where invalid input is not handled correctly.

**Dependency on sudo:** The script assumes that the user has sudo privileges to install applications. If not, the installation process may fail.

It's essential to review and test the script thoroughly, and adapt it to specific system configurations and security requirements.

## requirement

- git
- Active internet connection

## Tech Stack

**Script:** ShellScript

## Authors

- [@kpndevroot](https://www.github.com/kpndevroot)
