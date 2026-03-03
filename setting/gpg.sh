#!/usr/bin/env bash

# Function to display usage information
usage() {
    echo "Usage:"
    echo "  $0 import <gpg_file>     - Import GPG keys from file"
    echo "  $0 export <output_file>  - Export all GPG keys to file"
    echo "  $0 list                  - List all GPG keys"
    exit 1
}

# Check if at least one argument is provided
if [[ $# -lt 1 ]]; then
    usage
fi

# Get the operation from the first argument
operation="$1"

case "$operation" in
    import)
        if [[ $# -ne 2 ]]; then
            echo "Error: Import operation requires a GPG file as the second argument"
            usage
        fi
        
        gpg_file="$2"
        
        if [[ ! -f "$gpg_file" ]]; then
            echo "GPG file not found: $gpg_file"
            exit 1
        fi
        
        echo "Importing GPG keys from: $gpg_file"
        gpg --import "$gpg_file"
        echo "Import completed."
        ;;
        
    export)
        if [[ $# -ne 2 ]]; then
            echo "Error: Export operation requires an output file as the second argument"
            usage
        fi
        
        output_file="$2"
        
        echo "Exporting all GPG keys to: $output_file"
        
        if gpg --export --armor --output "$output_file"; then
            echo "Export completed successfully to: $output_file"
        else
            echo "Export failed"
            exit 1
        fi
        ;;
        
    list)
        echo "Listing GPG secret keys:"
        gpg --list-secret-keys
        echo
        echo "Listing all GPG keys:"
        gpg --list-keys
        ;;
        
    *)
        echo "Error: Unknown operation '$operation'"
        usage
        ;;
esac
