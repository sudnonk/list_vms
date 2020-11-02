#!/bin/bash

usage_exit() {
  cat <<EOT
  Usage: $(basename "$0") [json] [csv] [help]
  Description: Get information from Virtual Machines registered to Virtual Box.
  Options:
    json Print in JSON format.
    csv  Print in CSV format.
    help Print this message.
EOT
  exit 1
}

# VMの状態を読み取る。第一引数はVM名
describe_state() {
  /usr/bin/VBoxManage showvminfo "$1" | grep "State:" | awk -F':' '{print $2}' | awk -F'(' '{print $1}' | sed s/\ //g
}

# VMのCPU数を読み取る。第一引数はVM名
describe_cpu() {
  /usr/bin/VBoxManage showvminfo "$1" | grep "Number of CPUs" | awk -F':' '{print $2}' | sed s/\ //g
}

# VMのメモリサイズを読み取る。第一引数はVM名
describe_memory() {
  /usr/bin/VBoxManage showvminfo "$1" | grep "Memory size" | awk -F' ' '{print $3}'
}

# VMのディスク容量を読み取る。第一引数はVM名
describe_storage() {
  /usr/bin/VBoxManage list hdds | grep -3 "$1" | grep "Capacity" | awk -F':' '{print $2}' | sed s/\ //g
}

# CSV形式で出力する。引数は順番にVM名、状態、CPU数、メモリサイズ、ディスク容量
print_as_csv() {
  HDD_L=$(echo "$5" | wc -l)
  if [ "${HDD_L}" -gt 1 ]; then
    HDD=$(echo "$5" | tr '\n' ', ')
  else
    HDD="$5"
  fi

  echo "$1, $2, $3, $4, ${HDD}"
}

# JSON形式で出力する。引数は順番にVM名、状態、CPU数、メモリサイズ、ディスク容量
print_as_json() {
  HDD_L=$(echo "$5" | wc -l)
  if [ "${HDD_L}" -gt 1 ]; then
    HDD=$(echo "$5" | sed -r "s/^(.*)$/\"\1\", /g")
  else
    HDD="\"$5\""
  fi

  cat <<JSON
  {
    "name": "$1",
    "state": "$2",
    "cpu": "$3",
    "memory": "$4",
    "disk": [
      ${HDD}
    ]
  },
JSON
}

vms=$(/usr/bin/VBoxManage list vms | awk -F' ' '{print $1}' | sed s/\"//g)

case $1 in
json)
  IS_JSON=1
  ;;
csv)
  IS_CSV=1
  ;;
help)
  usage_exit
  ;;
*)
  usage_exit
  ;;
esac

if [[ $IS_JSON ]]; then
  echo "["

fi

if [[ $IS_CSV ]]; then
  echo "name, state, cpu, memory, storage"
fi

for vm in ${vms}; do
  if [[ $IS_JSON ]]; then
    print_as_json "${vm}" "$(describe_state "${vm}")" "$(describe_cpu "${vm}")" "$(describe_memory "${vm}")" "$(describe_storage "${vm}")"
  fi
  if [[ $IS_CSV ]]; then
    print_as_csv "${vm}" "$(describe_state "${vm}")" "$(describe_cpu "${vm}")" "$(describe_memory "${vm}")" "$(describe_storage "${vm}")"
  fi
done

if [[ $IS_JSON ]]; then
  echo "]"
fi

exit 0