#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Change to script directory so relative paths work
cd "$SCRIPT_DIR"

# Check if ImageMagick is installed
check_imagemagick() {
    if ! command -v convert &> /dev/null; then
        echo "ERROR: ImageMagick is not installed!"
        echo ""
        echo "This script requires ImageMagick to process images."
        echo ""
        echo "To install ImageMagick:"
        echo ""
        echo "Ubuntu/Debian:"
        echo "   sudo apt-get update"
        echo "   sudo apt-get install imagemagick"
        echo ""
        echo "macOS (with Homebrew):"
        echo "   brew install imagemagick"
        echo ""
        echo "Windows:"
        echo "   Download from: https://imagemagick.org/script/download.php#windows"
        echo ""
        echo "WSL (Windows Subsystem for Linux):"
        echo "   sudo apt-get update"
        echo "   sudo apt-get install imagemagick"
        echo ""
        exit 1
    else
        echo "SUCCESS: ImageMagick is installed: $(convert -version | head -n1)"
        echo ""
    fi
}

# Check ImageMagick before proceeding
check_imagemagick

# Set paths relative to script directory
src_path=./src
src_instruction_path=./src
ouput_path=./dist

# Counters for statistics
processed_files=0
created_images=0
skipped_images=0

req_img_widths=( 700 1400 )
req_img_resolutions=( 1400x1400 700x366 1400x732 600x314 )

#Common image sizes:
# - Twitter / FB "Large" = 600 x 314
# - Min Apple Publishing = 600 x 600

function fileExists()
{
    local dirname=$1
    local filename=$2
    if
        test -n "$(find ${dirname} -maxdepth 1 -name ${filename} -print -quit)"
    then
        return 0
    else
        return 1
    fi
}

function createImageAtSize()
{
    local src=$1
    local dest_dirname=$2
    local dest_filename=$3
    local resize=$4

    convert "${src}" \
        -resize ${resize} \
    ${dest_dirname}/${dest_filename}
}

function createImageAtSizeAndGravity()
{
    local src=$1
    local dest_dirname=$2
    local dest_filename=$3
    local resize=$4
    local gravity=$5

    convert "${src}" \
        -resize ${resize}^ \
        -gravity ${gravity} -extent ${resize} \
    ${dest_dirname}/${dest_filename}
}

FILES=$(find ${src_path} -type f -name '*.jpg' -or -name '*.png')
total_files=$(echo "$FILES" | wc -l)

echo "Found $total_files image files to process..."
echo ""

for f in $FILES
do
    ((processed_files++))
    echo "[$processed_files/$total_files] Processing: ${f}"

    src_file_basename=`basename "${f}"`
    src_file_no_ext=${src_file_basename%.*}
    src_file_ext=${src_file_basename:${#src_file_no_ext}}
    src_file_dirname=`dirname "${f}"`
    dest_dirname=${ouput_path}${src_file_dirname:${#src_path}}
    
    #Ensure output directory exists
    mkdir -p ${dest_dirname}

    ###################################
    # Generate specific instructions
    ###################################
    instruction_path=${src_instruction_path}${src_file_dirname:${#src_path}}
    instruction_types=( not-for-export gravity resolutions )
    
    #Defaults
    gravity="center"
    additionalResolutions=()

    #Overrides
    for instruction in ${instruction_types[@]}
    do
        instruction_file="${src_file_no_ext}.${instruction}"
        if
            $(fileExists ${instruction_path} ${instruction_file})
        then
            case "$instruction" in
                "not-for-export")
                    #Skip the file
                    echo "Info: File is marked 'not for export'!"
                    continue 2    
                    ;;
                
                "gravity")
                    #Apply specified gravity
                    echo "Info: Default gravity overridden!"
                    gravity=$(<${instruction_path}/${instruction_file})
                    ;;

                "resolutions")
                    #Include additional image resolutions
                    echo "Info: Additional resolutions apply and will be processed!"
                    additionalResolutions=( $(<${instruction_path}/${instruction_file}) )
                    ;;
            esac
        fi
    done

    ###################################
    # Generate specific widths
    ###################################
    for width in ${req_img_widths[@]}
    do
    #TODO: make sure that the source image is not smaller than the desired resolution
    
        filenameToWrite="${src_file_no_ext}-${width}w${src_file_ext}"
        #check if file already exists...
        if 
            $(fileExists ${dest_dirname} ${filenameToWrite})
        then
            echo "  SKIP: ${filenameToWrite} (already exists)"
            ((skipped_images++))
        else
            createImageAtSize ${f} ${dest_dirname} ${filenameToWrite} ${width}
            echo "  CREATED: ${filenameToWrite}"
            ((created_images++))
        fi

    done

    ###################################
    # Generate specific resolutions
    ###################################
    for resolution in ${req_img_resolutions[@]} ${additionalResolutions[@]}
    do
        filenameToWrite="${src_file_no_ext}-${resolution}${src_file_ext}"
        #check if file already exists...
        if 
            $(fileExists ${dest_dirname} ${filenameToWrite})
        then
            echo "  SKIP: ${filenameToWrite} (already exists)"
            ((skipped_images++))
        else
            createImageAtSizeAndGravity ${f} ${dest_dirname} ${filenameToWrite} ${resolution} ${gravity}
            echo "  CREATED: ${filenameToWrite}"
            ((created_images++))
        fi

    done

done

echo ""
echo "Image processing complete!"
echo ""
echo "Statistics:"
echo "   Files processed: $processed_files"
echo "   Images created: $created_images"  
echo "   Images skipped: $skipped_images"
echo ""
echo "Processed images are available in: ${ouput_path}/"
echo ""
echo "Usage tips:"
echo "   - Run this script from anywhere: ./images/build_images.sh"
echo "   - Or: cd images && ./build_images.sh"
echo "   - Place new images in: ${src_path}/"
echo "   - Generated sizes: ${req_img_widths[@]} widths + ${#req_img_resolutions[@]} specific resolutions"
echo ""