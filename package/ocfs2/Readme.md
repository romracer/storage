## Rancher OCFS2 Filesystem Volume Plugin Driver

Mount an OCFS2 filesystem for shared usage

### Requirements

* Host kernel support for recent versions of the OCFS2 file system (RancherOS tested with kernel-extras)
* Network IP address and hostname for each node (a private network is recommended)
  - Port 7777/tcp should be open between the hosts on this network
* Pre-partitioned and OCFS2-formatted block device attached to each node at the same location (ex. `/dev/disk/by-path/pci-0000:03:00.0-scsi-0:0:1:0-part1` or `/dev/disk/by-label/rancher-ocfs2`)
* The cluster name used for mkfs.ocfs2 **must** match the cluster name specified when deploying the driver in Rancher (alpha-numeric, max 16 characters).

An OCFS2 filesystem can be created in this container. A recommended sequence of commands to create one might be:
```
$ docker run -it --rm --privileged -v /dev:/host/dev romracer/storage-ocfs2:v0.6.6 /bin/bash
# mount --rbind /host/dev /dev
# parted --script /dev/disk/by-path/pci-0000:03:00.0-scsi-0:0:1:0 \
    mklabel gpt \
    mkpart primary 1MiB 100\%
# mkfs.ocfs2 --node-slots 16 --label rancher-ocfs2 -T mail --fs-feature-level=max-features --mount cluster --cluster-stack=o2cb --cluster-name=rancherocfs2 /dev/disk/by-path/pci-0000:03:00.0-scsi-0:0:1:0-part1
# exit
```
You might need to re-read the block device on your nodes now:
```
# blockdev --rereadpt /dev/disk/by-path/pci-0000:03:00.0-scsi-0:0:1:0
```
It is recommended to set the following sysctls for appropriate recovery of a failed node:
```
# sysctl -w kernel.panic=30
# sysctl -w kernel.panic_on_oops=1
```

### Limitations

* A maximum of 16 nodes is supported
* Only the o2cb cluster stack is supported
* Only local heartbeat mode is supported

### OCFS2 filesystem plugin driver is a bash script and invocation commands are:
**Create:**  
```
driver  create json_options
```

**Delete:**  
```
driver  delete json_options
```

**Mount:**
```
driver  mount  mountpoint  json_options
```

**Unmount:**
```
driver  unmount  mountpoint
```

**Other Functions:**  
attach, detach functions don't do anything.  

### Usage
Rancher hosts will have default backing device environment variable set identifying default block device.  Driver will use it to mount OCFS2 filesystem and create a directory for each volume during create command and delete it at delete command.  Directory is bind mounted to appropriate Rancher volume location on container start and unmounted on container stop.

For instance:
```
export BACKING_DEVICE=/dev/disk/by-label/rancher-ocfs2
```

#### Create command
user supplies volume name, driver creates a directory under default mount point using volume name.
The output is the status and newly created directory name

```
./ocfs2 create '{"name":"vol1"}'

name represents volume name.

stdout output: {"status": "Success”,"options":{"created":true,"name":"vol1”}}

the options map from the output will be passed in as part of json_input for delete command
```

#### Delete command
driver deletes created directory at create phase

```
./ocfs2 delete '{"mntDest":"/home/ubuntu/mnt", "created":"true", "name":"vol1"}'

the options map from create command output is passed in to delete command as part of json_input

stdout output: {"status":"Success","message":""}
```

#### Mount command
driver bind mounts OCFS2 source directory created at create command phase

```
./ocfs2 mount /home/ubuntu/mnt '{"name":"vol1"}'

name is a must

stdout output: {"status":"Success","message":""}
```

#### Unmount command
driver unmount OCFS2 bind mount

```
./ocfs2 unmount /home/ubuntu/mnt

stdout output: {"status":"Success","message":""}
```
