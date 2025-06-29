#!/bin/bash

echo -e "\e[31mMinimum password requirements\e[0m"
echo -e "\e[31mAt least 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character\e[0m"

# Prompt user for password (silent input)
read -sp "Enter your password: " password
echo

# Check password length
if [ ${#password} -lt 8 ]; then
    echo "❌ Password must be at least 8 characters long."

# Check for at least one uppercase letter
elif ! [[ "$password" =~ [A-Z] ]]; then
    echo "❌ Password must contain at least one uppercase letter."

# Check for at least one lowercase letter
elif ! [[ "$password" =~ [a-z] ]]; then
    echo "❌ Password must contain at least one lowercase letter."

# Check for at least one digit
elif ! [[ "$password" =~ [0-9] ]]; then
    echo "❌ Password must contain at least one digit."

# ✅ Escape special characters properly (especially & and -)
elif ! [[ "$password" =~ [@#\$%\^\&\*\!_\+\-=] ]]; then
    echo "❌ Password must contain at least one special character (@, #, $, %, etc.)."

else
    echo "✅ Password is strong!"
fi
