echo "${CHANGED_FILES}"
for str in ${CHANGED_FILES[@]}; do
  echo $str
done

echo "hello"
echo "${changedfiles[@]}"

file_names_to_ignore=("changelog.xml", "pom.xml", "ReadMe.md")

# Remove files of .github directory from list
for i in "${!changedfiles[@]}"; do
    if [[ "${changedfiles[i]}" == .github* ]]; then
        unset 'changedfiles[i]'
    fi
done

# Get unique directories and file names
unique_dirs=()
unique_file_names=()
for i in "${!changedfiles[@]}"; do
    if [[ ! " ${file_names_to_ignore[*]} " =~ " ${changedfiles[i]##*/} " ]]; then
        unique_file_names+=(${changedfiles[i]##*/})
    fi
    IFS='/' read -ra path <<< "${changedfiles[i]%/*}/"
    for i in "${path[@]}"; do
        if [[ ! " ${unique_dirs[*]} " =~ " ${i} " ]]; then
            unique_dirs+=(${i})
        fi
    done
done

# Get Invalid Directory names
invalid_dirs=()
for dir in "${unique_dirs[@]}"; do
    if [[ ! "${dir}" =~ ^[A-Z0-9._]*$ ]]; then
        invalid_dirs+=(${dir}) 
    fi
done

# Get Invalid file names
invalid_file_names=()
for file_name in "${unique_file_names[@]}"; do
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