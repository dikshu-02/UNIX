#!/bin/bash

# User Account Management Utility
# Author: Dikshitha Vani V

# Ensure script is run with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "[-] Error: This script must be run as root (sudo)." >&2
    exit 1
fi

LOG_FILE="/var/log/user_management.log"

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

print_menu() {
    echo "=============================="
    echo "   USER MANAGEMENT UTILITY    "
    echo "=============================="
    echo "1. Create New User"
    echo "2. Delete User"
    echo "3. Exit"
}

create_user() {
    read -p "Enter username to create: " username
    
    # Check if user already exists
    if id "$username" &>/dev/null; then
        echo "[-] User '$username' already exists."
        return
    fi

    read -p "Enter default shell (e.g., /bin/bash): " shell
    shell=${shell:-/bin/bash} # Default to bash if empty

    read -s -p "Enter password for $username: " password
    echo ""

    # Create user with home directory and specified shell
    useradd -m -s "$shell" "$username"
    
    if [ $? -eq 0 ]; then
        # Set password securely
        echo "$username:$password" | chpasswd
        log_action "SUCCESS: Created user '$username' with shell '$shell'."
        echo "[+] User '$username' successfully created."
    else
        log_action "FAILED: Could not create user '$username'."
        echo "[-] Error creating user."
    fi
}

delete_user() {
    read -p "Enter username to delete: " username

    if ! id "$username" &>/dev/null; then
        echo "[-] User '$username' does not exist."
        return
    fi

    read -p "Do you want to remove the home directory and mail spool? (y/n): " remove_home
    
    if [ "$remove_home" = "y" ]; then
        userdel -r "$username"
        log_action "SUCCESS: Deleted user '$username' and removed home directory."
    else
        userdel "$username"
        log_action "SUCCESS: Deleted user '$username' (home directory retained)."
    fi
    echo "[+] User '$username' deleted successfully."
}

# Main Loop
while true; do
    print_menu
    read -p "Select an option [1-3]: " choice
    case $choice in
        1) create_user ;;
        2) delete_user ;;
        3) echo "Exiting utility."; exit 0 ;;
        *) echo "[-] Invalid option. Please choose 1, 2, or 3." ;;
    esac
    echo ""
done
