#!/bin/bash
src_path=./src
ouput_path=./output

req_img_res=( 300 600 800 1000)

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

    # echo "src_file_dirname: "${src_file_dirname}
    # echo "Path to write to: "${dest_dirname}
    mkdir -p ${dest_dirname}

    # attempt to create an image at each required resolution
    for res in ${req_img_res[@]}
    do

    #TODO: make sure that the source image is not smaller than the desired resolution
    
        #check if file already exists...
        if test -n "$(find ${dest_dirname} -maxdepth 1 -name ${src_file_no_ext}-${res}x*.jpg -print -quit)"
        then
            echo "  Skipped: "[ ${dest_dirname}/${src_file_no_ext}-${res}x*.jpg ];
        else
            echo "  - Generating file image @ pixel resolution: "${res}
            magick "${f}" -resize ${res} -set filename:area '%wx%h' ${dest_dirname}/${src_file_no_ext}-%[filename:area].jpg
            echo "    - Created: "[ ${dest_dirname}/${src_file_no_ext}-${res}x*.jpg ];
        fi

    done
    magick "${f}" -resize 300x300^ \
        -gravity west -extent 300x300 \
        -set filename:area '%wx%h' ${dest_dirname}/${src_file_no_ext}-%[filename:area].jpg

done
