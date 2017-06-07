#!/bin/bash
src_path=./src
src_instruction_path=./src
ouput_path=./dist

req_img_widths=( 700 1400 )
req_img_resolutions=( 1200x1200 600x314 1200x628 )

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
        echo True
    else
        echo False
    fi
}

function createImageAtSize()
{
    local src=$1
    local dest_dirname=$2
    local dest_filename=$3
    local resize=$4

    magick "${src}" \
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

    magick "${src}" \
        -resize ${resize}^ \
        -gravity ${gravity} -extent ${resize} \
    ${dest_dirname}/${dest_filename}
}

FILES=$(find ${src_path} -type f -name '*.jpg')
for f in $FILES
do
    echo
    echo "--------------"
    echo "Processing: "${f}

    src_file_basename=`basename "${f}"`
    src_file_no_ext=${src_file_basename%.*}
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
    
        filenameToWrite="${src_file_no_ext}-${width}w.jpg"
        #check if file already exists...
        if 
            $(fileExists ${dest_dirname} ${filenameToWrite})
        then
            echo "  Skipped: "[ ${dest_dirname}/${filenameToWrite} ];
        else
            createImageAtSize ${f} ${dest_dirname} ${filenameToWrite} ${width}
            echo "    - Created: "[ ${dest_dirname}/${filenameToWrite} ];
        fi

    done

    ###################################
    # Generate specific resolutions
    ###################################
    for resolution in ${req_img_resolutions[@]}
    do
        filenameToWrite="${src_file_no_ext}-${resolution}.jpg"
        #check if file already exists...
        if 
            $(fileExists ${dest_dirname} ${filenameToWrite})
        then
            echo "  Skipped: "[ ${dest_dirname}/${filenameToWrite} ];
        else
            createImageAtSizeAndGravity ${f} ${dest_dirname} ${filenameToWrite} ${resolution} ${gravity}
            echo "    - Created: "[ ${dest_dirname}/${filenameToWrite} ];
        fi

    done

    ###################################
    # Additional (custom) resolutions
    ###################################
    for resolution in ${additionalResolutions[@]}
    do
        filenameToWrite="${src_file_no_ext}-${resolution}.jpg"
        #check if file already exists...
        if 
            $(fileExists ${dest_dirname} ${filenameToWrite})
        then
            echo "  Skipped: "[ ${dest_dirname}/${filenameToWrite} ];
        else
            createImageAtSizeAndGravity ${f} ${dest_dirname} ${filenameToWrite} ${resolution} ${gravity}
            echo "    - Created: "[ ${dest_dirname}/${filenameToWrite} ];
        fi

    done

done
