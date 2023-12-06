#!/bin/bash

declare -A installed_status

os_options=("Arch" "Ubuntu" "Fedora")
Arch_apps=("firefox" "google-chrome" "visual-studio-code-bin" "vim" "vlc" "postgresql" "pulseaudio" "jdk-openjdk" "mongodb-bin" "mongodb-compass" "mongodb-tools-bin" "android-studio" "android-tools" "brave-bin" "geekbench")
Ubuntu_apps=("build-essential" "wget" "curl" "vim" "firefox" "vlc" "default-jre default-jdk")  # Add applications for Ubuntu
Fedora_apps=("firefox" "google-chrome-stable" "code")

welcome_message() {
    echo "Welcome to the OS Application Installer"
}

update_system() {
    read -p "Do you want to update the mirror and upgrade the system? [y/n]: " update_choice
    case $update_choice in
        [Yy])
            case $(uname -s) in
                "Linux")
                    if command -v pacman &> /dev/null; then
                        sudo pacman -Syu
                    elif command -v apt-get &> /dev/null; then
                        sudo apt-get update
                        sudo apt-get upgrade -y
                    elif command -v dnf &> /dev/null; then
                        sudo dnf update -y
                    else
                        echo "No supported package manager found. Exiting."
                        exit 1
                    fi
                    ;;
                *)
                    echo "Unsupported operating system. Exiting."
                    exit 1
                    ;;
            esac
            ;;
        [Nn])
            echo "Skipping system update."
            ;;
        *)
            echo "Invalid choice. Please enter 'y' or 'n'."
            update_system
            ;;
    esac
}

check_package_manager() {
    local package_manager=$1
    if ! command -v $package_manager &> /dev/null; then
        echo "$package_manager not found. Please install it on your system."
        exit 1
    fi
}

check_package_managers() {
    case $(uname -s) in
        "Linux")
            if command -v pacman &> /dev/null; then
                check_package_manager "pacman"
            elif command -v apt-get &> /dev/null; then
                check_package_manager "apt-get"
            elif command -v dnf &> /dev/null; then
                check_package_manager "dnf"
            else
                echo "No supported package manager found. Exiting."
                exit 1
            fi
            ;;
        *)
            echo "Unsupported operating system. Exiting."
            exit 1
            ;;
    esac
}

display_options() {
    echo "Select an operating system:"
    for i in "${!os_options[@]}"; do
        echo "$((i + 1)). ${os_options[$i]}"
    done
    echo "$((i + 2)). Exit"
}

select_os() {
    read -p "Enter your choice: " os_choice
    update_system  # Update system after selecting the operating system
}

display_applications() {
    local os=$1
    local apps_var="${os}_apps[@]"
    local apps=("${!apps_var}")

    echo "Applications available for $os:"
    
    for i in "${!apps[@]}"; do
        status="${installed_status[${apps[$i]}]}"
        installed="[Not Installed]"

        # Check if the package is already installed
        case $os in
            "Arch")
                if command -v pacman &> /dev/null && pacman -Qs ${apps[$i]} >/dev/null; then
                    installed="[Installed]"
                fi
                ;;
            "Ubuntu")
                if command -v dpkg &> /dev/null && dpkg -l | grep -q "^ii  ${apps[$i]} "; then
                    installed="[Installed]"
                fi
                ;;
            "Fedora")
                if command -v rpm &> /dev/null && rpm -q ${apps[$i]} >/dev/null; then
                    installed="[Installed]"
                fi
                ;;
        esac

        echo "$((i + 1)). ${apps[$i]} - $installed"
    done

    echo "$((i + 2)). Install All"
    echo "$((i + 3)). Back"
}

select_application() {
    read -p "Enter your choice: " app_choice
}

install_application() {
    local os=$1
    local apps_var="${os}_apps[@]"
    local apps=("${!apps_var}")

    if [ ${#apps[@]} -eq 0 ]; then
        echo "No applications available for installation on $os."
        return
    fi

    if [ "$app_choice" -eq $((i + 2)) ]; then
        # Install all available applications
        for app in "${apps[@]}"; do
            case $os in
                "Arch")
                    if command -v pacman &> /dev/null && ! pacman -Qs $app >/dev/null; then
                        sudo pacman -S --noconfirm $app
                        installed_status["$app"]="Installed"
                    fi
                    ;;
                "Ubuntu")
                    if command -v dpkg &> /dev/null && ! dpkg -l | grep -q "^ii  $app "; then
                        sudo apt-get install -y $app
                        installed_status["$app"]="Installed"
                    fi
                    ;;
                "Fedora")
                    if command -v rpm &> /dev/null && ! rpm -q $app >/dev/null; then
                        sudo dnf install -y $app
                        installed_status["$app"]="Installed"
                    fi
                    ;;
            esac
        done

        echo "All available applications have been installed on $os."
        return
    fi

    local app=${apps[$((app_choice - 1))]}

    case $os in
        "Arch")
            if command -v pacman &> /dev/null && pacman -Qs $app >/dev/null; then
                echo "$app is already installed on Arch."
            else
                sudo pacman -S --noconfirm $app
            fi
            ;;
        "Ubuntu")
            if command -v dpkg &> /dev/null && dpkg -l | grep -q "^ii  $app "; then
                echo "$app is already installed on Ubuntu."
            else
                sudo apt-get install -y $app
            fi
            ;;
        "Fedora")
            if command -v rpm &> /dev/null && rpm -q $app >/dev/null; then
                echo "$app is already installed on Fedora."
            else
                sudo dnf install -y $app
            fi
            ;;
    esac

    installed_status["$app"]="Installed"
}

display_status() {
    echo "Status:"
    for os in "${os_options[@]}"; do
        apps_var="${os}_apps[@]"
        local apps=("${!apps_var}")

        echo "$os - Applications:"
        for i in "${!apps[@]}"; do
            status="${installed_status[${apps[$i]}]}"
            installed="[Not Installed]"

            # Check if the package is already installed
            case $os in
                "Arch")
                    if command -v pacman &> /dev/null && pacman -Qs ${apps[$i]} >/dev/null; then
                        installed="[Installed]"
                    fi
                    ;;
                "Ubuntu")
                    if command -v dpkg &> /dev/null && dpkg -l | grep -q "^ii  ${apps[$i]} "; then
                        installed="[Installed]"
                    fi
                    ;;
                "Fedora")
                    if command -v rpm &> /dev/null && rpm -q ${apps[$i]} >/dev/null; then
                        installed="[Installed]"
                    fi
                    ;;
            esac

            echo "  ${apps[$i]} - $installed"
        done
    done
}

main() {
    check_package_managers

    welcome_message

    while true; do
        display_options
        select_os

        case $os_choice in
            $((i + 2)))
                echo "Exiting the OS Application Installer. Goodbye!"
                exit 0
                ;;
            *)
                os=${os_options[$((os_choice - 1))]}

                while true; do
                    display_applications "$os"
                    select_application

                    case $app_choice in
                        $((i + 2)))
                            install_application "$os" "all"
                            break
                            ;;
                        $((i + 3)))
                            break
                            ;;
                        *)
                            install_application "$os"
                            ;;
                    esac
                done
                ;;
        esac
    done
}

main
