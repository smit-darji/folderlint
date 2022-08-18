echo "${CHANGED_FILES}"
echo 
# for str in ${CHANGED_FILES[@]}; do
#   echo $str
# done
# mapfile -t changedfiles < <("${CHANGED_FILES}")
arr=("")
arr+=("${CHANGED_FILES}")
echo ${arr[@]}


file_names_to_ignore=("changelog.xml", "pom.xml", "ReadMe.md")

# Remove files of .github directory from list
for i in "${!arr[@]}"; do
    if [[ "${arr[i]}" == .github* ]]; then
        unset 'arr[i]'
        echo "Failed To Remove files of .github directory from list"
        exit 1
    fi
done

# Get unique directories and file names
unique_dirs=()
unique_file_names=()
for i in "${!arr[@]}"; do
    if [[ ! " ${file_names_to_ignore[*]} " =~ " ${arr[i]##*/} " ]]; then
        unique_file_names+=(${arr[i]##*/})
        echo "Invalid Unique File Name ${arr[i]##*/})"
        exit 1
    fi
    IFS='/' read -ra path <<< "${arr[i]%/*}/"
    for i in "${path[@]}"; do
        if [[ ! " ${unique_dirs[*]} " =~ " ${i} " ]]; then
            unique_dirs+=(${i})
            echo "Invalid Unique Directory Name ${i})"
            exit 1
        fi
    done
done

# Get Invalid Directory names
invalid_dirs=()
for dir in "${unique_dirs[@]}"; do
    if [[ ! "${dir}" =~ ^[A-Z0-9._]*$ ]]; then
        invalid_dirs+=(${dir}) 
        echo "Invalid Directory Name ${dir})"
        exit 1
    fi
done

# Get Invalid file names
invalid_file_names=()
for file_name in "${unique_file_names[@]}"; do
    if [[ ! "${file_name}" =~ [0-9]{4}_[A-Z0-9_]*.[a-zA-Z]*$ ]]; then
        invalid_file_names+=(${file_name})
        echo "Invalid FIleName ${file_name})"
        exit 1
    fi
done

if [[ ! -z "$invalid_dirs" || ! -z "$invalid_file_names" ]]; 
    then
        echo "Failed!!"
        if [[ ! -z "$invalid_dirs" ]]; then
            echo "${invalid_dirs[@]}"
            echo "Invalid Directory ${invalid_dirs[@]} "
            exit 1
        fi 
        if [[ ! -z "$invalid_file_names" ]]; then
            echo "${invalid_file_names[@]}"
            echo "Invalid FileName ${invalid_dirs[@]} "
            exit 1
        fi
    else
        echo "Success!!"
fi