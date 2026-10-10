# User Account Management Utility
# Author: Dikshitha Vani V

while [ 1 ]
do
    echo "Menu"
    echo "1. Create User"
    echo "2. Delete User"
    echo "3. List Users"
    echo "4. Quit"
    read -p "Enter your choice: " choice
    
    case "$choice" in
    1) 
       read -p "Enter username to create: " username
       if id "$username" &>/dev/null
       then
           echo "User $username already exists"
       else
           echo "Checking root permissions for user creation..."
           sudo useradd -m "$username"
           if [ $? -eq 0 ]
           then
               echo "User $username successfully created"
           else
               echo "Failed to create user $username. Please ensure you have root/sudo privileges."
           fi
       fi
       ;;
    2) 
       read -p "Enter username to delete: " username
       if id "$username" &>/dev/null
       then
           echo "Checking root permissions for user deletion..."
           sudo userdel -r "$username"
           if [ $? -eq 0 ]
           then
               echo "User $username deleted successfully"
           else
               echo "Failed to delete user $username. Please ensure you have root/sudo privileges."
           fi
       else
           echo "User $username does not exist"
       fi
       ;;
    3) 
       echo "List of system users:"
       awk -F: '{print $1}' /etc/passwd
       ;;
    4) 
       echo "Exiting the program"
       break
       ;;
    *) 
       echo "Wrong choice $choice"
       ;;
    esac
    echo ""
done
