#!/bin/bash

# Function to display usage information
usage() {
    # echo "Usage: $0 --name <name> --mail <email> [--gpg <true|false>] [--token <token>]"
    echo "Usage: $0 --name <name> --mail <email> [--gpg <true|false>]"
    exit 1
}

# Default value for GPG creation
CREATE_GPG=true

# Parse input parameters
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --name) NAME="$2"; shift ;;
        --mail) EMAIL="$2"; shift ;;
        --gpg) CREATE_GPG="$2"; shift ;;
        # --token) TOKEN="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

# Check if required parameters are provided
if [ -z "$NAME" ] || [ -z "$EMAIL" ]; then
    usage
fi

# Check if the current directory contains a Git repository
if [ ! -d .git ]; then
    echo "No Git repository found. Initializing a new Git repository..."
    git init
    git config --local user.name "$NAME"
    git config --local user.email "$EMAIL"
    echo "Git repository initialized and configuration set successfully."
else
    # Get the current Git configuration
    CURRENT_NAME=$(git config --local user.name)
    CURRENT_EMAIL=$(git config --local user.email)

    # Check and update Git configuration
    if [ -z "$CURRENT_NAME" ] && [ -z "$CURRENT_EMAIL" ]; then
        echo "No local Git configuration found. Setting configuration now..."
        git config --local user.name "$NAME"
        git config --local user.email "$EMAIL"
        echo "Git configuration updated successfully."
    elif [ "$CURRENT_NAME" != "$NAME" ] || [ "$CURRENT_EMAIL" != "$EMAIL" ]; then
        echo "Local Git configuration does not match the new data."
        echo "Current Git configuration:"
        echo "Name: $CURRENT_NAME"
        echo "Email: $CURRENT_EMAIL"
        read -p "Do you want to update the data with the new values (name: $NAME, email: $EMAIL)? (y/n): " RESPONSE
        if [ "$RESPONSE" = "y" ]; then
            git config --local user.name "$NAME"
            git config --local user.email "$EMAIL"
            echo "Git configuration updated successfully."
        else
            echo "Git configuration not updated."
        fi
    else
        echo "The local Git configuration already matches the provided parameters."
    fi
fi

# Show the current Git configuration
echo "Current Git configuration:"
git config --local --list

# Check and generate GPG key if CREATE_GPG is true
if [ "$CREATE_GPG" = true ]; then
    GPG_KEY=$(gpg --list-secret-keys --keyid-format LONG | grep 'sec' | awk '{print $2}' | cut -d'/' -f2)

    if [ -z "$GPG_KEY" ]; then
        echo "No existing GPG key found. Generating a new GPG key..."
        gpg --batch --generate-key <<EOF
        Key-Type: default
        Subkey-Type: default
        Name-Real: $NAME
        Name-Email: $EMAIL
        Expire-Date: 0
        %commit
EOF
        GPG_KEY=$(gpg --list-secret-keys --keyid-format LONG | grep 'sec' | awk '{print $2}' | cut -d'/' -f2)
        echo "GPG key generated successfully. Key: $GPG_KEY"
    else
        echo "Existing GPG key found: $GPG_KEY"
        read -p "Do you want to generate a new GPG key specifically for these details? (y/n): " GENERATE_NEW_GPG
        if [ "$GENERATE_NEW_GPG" = "y" ]; then
            gpg --batch --generate-key <<EOF
            Key-Type: default
            Subkey-Type: default
            Name-Real: $NAME
            Name-Email: $EMAIL
            Expire-Date: 0
            %commit
EOF
            GPG_KEY=$(gpg --list-secret-keys --keyid-format LONG | grep 'sec' | awk '{print $2}' | cut -d'/' -f2)
            echo "New GPG key generated successfully. Key: $GPG_KEY"
        else
            echo "The existing GPG key will be retained."
        fi
    fi

    # Configure Git to sign commits with the GPG key
    git config --local user.signingkey $GPG_KEY
    git config --local commit.gpgSign true

    # Display the GPG key for synchronization with GitHub
    echo "GPG key for synchronization with GitHub:"
    gpg --armor --export $GPG_KEY
fi

# Configure Git to use the provided token for authentication
# if [ -n "$TOKEN" ]; then
#     echo "Configuring Git to use the provided token for authentication..."
#     git config --global credential.helper store
#     echo "https://USERNAME:$TOKEN@github.com" > ~/.git-credentials
#     echo "Git configured to use the provided token for authentication."
# fi

echo "Git configuration completed successfully."

