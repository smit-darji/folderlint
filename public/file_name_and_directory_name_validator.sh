echo "${CHANGED_FILES}"
echo 
# for str in ${CHANGED_FILES[@]}; do
#   echo $str
# done
# mapfile -t changedfiles < <("${CHANGED_FILES}")
arr=("")
arr+=("${CHANGED_FILES}")
echo ${arr[@]}
echo "hello"


file_names_to_ignore=("changelog.xml", "pom.xml", "ReadMe.md")

# Remove files of .github directory from list
for i in "${!arr[@]}"; do
    echo "Yout are in ignore file"
    if [[ "${arr[i]}" == .github* ]]; then
        unset 'arr[i]'
    fi
done

# Get unique directories and file names
unique_dirs=()
unique_file_names=()
for i in "${!arr[@]}"; do
    if [[ ! " ${file_names_to_ignore[*]} " =~ " ${arr[i]##*/} " ]]; then
        echo "Yout are in unique dir"
        unique_file_names+=(${arr[i]##*/})
    fi
    IFS='/' read -ra path <<< "${arr[i]%/*}/"
    for i in "${path[@]}"; do
        echo "Yout are in split"
        if [[ ! " ${unique_dirs[*]} " =~ " ${i} " ]]; then
            unique_dirs+=(${i})
        fi
    done
done

# Get Invalid Directory names
invalid_dirs=()
for dir in "${unique_dirs[@]}"; do
    echo "Yout are in  dir name"
    if [[ ! "${dir}" =~ ^[A-Z0-9._]*$ ]]; then
        invalid_dirs+=(${dir}) 
    fi
done

# Get Invalid file names
invalid_file_names=()
for file_name in "${unique_file_names[@]}"; do
    echo "Yout are in invalid filename"
    if [[ ! "${file_name}" =~ [0-9]{4}_[A-Z0-9_]*.[a-zA-Z]*$ ]]; then
        invalid_file_names+=(${file_name}) 
    fi
done

if [[ ! -z "$invalid_dirs" || ! -z "$invalid_file_names" ]]; 
    then
        echo "Failed!!"
        if [[ ! -z "$invalid_dirs" ]]; then
            echo "Invalid Directory Names"
            echo "${invalid_dirs[@]}"
        fi 
        if [[ ! -z "$invalid_file_names" ]]; then
            echo "Invalid File Names"
            echo "${invalid_file_names[@]}"
        fi
    else
        echo "Success!!"
fi