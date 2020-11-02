# list_vms
Describe VirtualBox VMs' Name, State, CPUs, Memory size, Storage size.

## Usage

To get as CSV format, execute like below.

```bash
# ./list_vms.sh csv
name, state, cpu, memory, storage
web01, poweredoff, 4, 2048MB, 51200MBytes,
web02, poweredoff, 4, 2028MB, 51200MBytes,
app1, running, 2, 4096MB, 102400MBytes,
db1, poweredoff, 1, 1024MB, 51200MBytes,51200MBytes
db2, poweredoff, 1, 1024MB, 51200MBytes,51200MBytes
```

To get as JSON format, execute like below.

```
# ./list_vms.sh json
[
  {
    "name": "web01",
    "state": "poweredoff",
    "cpu": "4",
    "memory": "4096MB",
    "disk": [
      "51200MBytes",
      "102400MBytes",
    ]
  },
]
```

*** Note: In json format, the trailing comma exists. *** Please use parser which allow that.

You can pipe these to file or other scripts.

## Requirements

- Linux
- `/bin/bash` exists.
- `/usr/bin/VBoxManage` exists.
- sudo privilege may needed to execute `/usr/bin/VBoxManage`

## Install

1. Download `list_vms.sh`
2. `chmod +x list_vms.sh`
3. Command `./list_vms.sh json` or `./list_vms.sh csv`