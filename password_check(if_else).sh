#!/bin/bash

echo "Minimum password requirements"
echo "At least 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character"

# Prompt user for password (silent input)
read -sp "Enter your password: " password
echo

# Check length
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

# Check for at least one special character (from a safe set)
elif ! [[ "$password" =~ [@#$%^&*!_\-+=] ]]; then
    echo "❌ Password must contain at least one special character (@, #, $, %, etc.)."

else
    echo "✅ Password is strong!"
fi
