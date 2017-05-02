#!/bin/bash
src_path=./src
ouput_path=./output

req_img_widths=( 300 600 800 1000)
req_img_resolutions=( 300x300 600x314)

#Common image sizes:
# - Twitter / FB "Large" = 600 X 314


# echo src_path: ${src_path}
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

    if
        test -n "$(find ${src_file_dirname} -maxdepth 1 -name ${src_file_no_ext}-gravity-* -print -quit)"
    then
        gravitymap=$(find ${src_file_dirname} -maxdepth 1 -name ${src_file_no_ext}-gravity-* -print -quit)
        echo "Gravity Map = " ${gravitymap}
        gravity=${gravitymap:${#src_file_dirname}+${#src_file_no_ext}+10}
        echo "Gravity = " ${gravity}
    else
        gravity=center
    fi

    # echo "src_file_dirname: "${src_file_dirname}
    # echo "Path to write to: "${dest_dirname}
    mkdir -p ${dest_dirname}

    # attempt to create an image at each required width
    for width in ${req_img_widths[@]}
    do
    #TODO: make sure that the source image is not smaller than the desired resolution
    
        #check if file already exists...
        if test -n "$(find ${dest_dirname} -maxdepth 1 -name ${src_file_no_ext}-${width}x*.jpg -print -quit)"
        then
            echo "  Skipped: "[ ${dest_dirname}/${src_file_no_ext}-${width}x*.jpg ];
        else
            echo "  - Generating file image @ pixel width: "${width}
            magick "${f}" -resize ${width} \
                -set filename:area '%wx%h' ${dest_dirname}/${src_file_no_ext}-%[filename:area].jpg
            echo "    - Created: "[ ${dest_dirname}/${src_file_no_ext}-${width}x*.jpg ];
        fi

    done

    for resolution in ${req_img_resolutions[@]}
    do

    #TODO: make sure that the source image is not smaller than the desired resolution
    
        #check if file already exists...
        if
            test -n "$(find ${dest_dirname} -maxdepth 1 -name ${src_file_no_ext}-${resolution}.jpg -print -quit)"
        then
            echo "  Skipped: "[ ${dest_dirname}/${src_file_no_ext}-${resolution}.jpg ];
        elif
            test -n "$(find ${dest_dirname} -maxdepth 1 -name ${src_file_no_ext}-crop-${resolution}.jpg -print -quit)"
        then
            echo "  Skipped: "[ ${dest_dirname}/${src_file_no_ext}-crop-${resolution}.jpg ];
        else
            echo "  - Generating file image @ pixel resolution: "${resolution}
            magick "${f}" -resize ${resolution}^ \
                -gravity ${gravity} -extent ${resolution} \
                -set filename:area '%wx%h' ${dest_dirname}/${src_file_no_ext}-crop-%[filename:area].jpg
            echo "    - Created: "[ ${dest_dirname}/${src_file_no_ext}-crop-${resolution}.jpg ];
        fi

    done



done
