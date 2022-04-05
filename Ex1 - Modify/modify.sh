#!/usr/bin/sh

# Recursive mode.
RECURSIVE="false"


# Modifies filenames according to the arguments.
modify(){
    local FILENAME=$(basename "$1") 
    local PATHNAME=$(dirname "$1")

   case "$OPTION" in
        LO)
            local NEWNAME="$(echo "$FILENAME" | tr [:upper:] [:lower:])" ;;
        UP)
            local NEWNAME="$(echo "$FILENAME" | tr [:lower:] [:upper:])" ;;
        SED)
            local NEWNAME="$(echo "$FILENAME" | sed -s "$sed_pattern")" ;;
    esac

    if [ "$1" != "${PATHNAME}/${NEWNAME}" ]; then
        mv -- "$1" "${PATHNAME}/${NEWNAME}"  
    fi
}


# Modifies every file in the given directory and its subdirectories
modify_recursive(){

    for file in "$1"/* ; do
        if [ -f "$file" ]; then
            modify "$file" "$option" "$sed_p"
        elif [ -d "$file" ]; then
            modify_recursive "$file" "$option" "$sed_p"
        else
            break
        fi
    done

}


help(){
echo "


"

}

# Check if parameters exist
if [ $# -eq 0 ]; then
    echo "No parameters provided."
    exit
fi

# Check recursion
case "$1" in
    -r ) RECURSIVE="true" shift ;;
esac

case "$1" in
    -u ) OPTION=UP ;;
    -l ) OPTION=LO ;;
     * ) OPTION=SED sed_pattern=$1 ;;
    -h ) help exit ;;
esac

# Checking if $2 is null
while [ -n "$2" ]; do           
    # Checking if path exists.  
    if ! [ -e "./$2" ]; then      
        echo "not a valid input!"
        exit
    fi

    if [ $RECURSIVE = "true" ]; then
        if [ -f "./$2" ]; then
            modify "./$2" "$OPTION"
        else
            modify_recursive "./$2" "$OPTION"
        fi
    else
        if [ -f "./$2" ]; then
            modify "./$2" "$OPTION"
        fi
    fi
    shift
done
