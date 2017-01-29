#!/bin/bash

cat << EOF | debconf-set-selections
ocfs2-tools ocfs2-tools/idle_timeout  select 30000
ocfs2-tools ocfs2-tools/reconnect_delay select 2000
ocfs2-tools ocfs2-tools/init select true
ocfs2-tools ocfs2-tools/clustername select rancher-ocfs2
ocfs2-tools ocfs2-tools/heartbeat_threshold select 31
ocfs2-tools ocfs2-tools/keepalive_delay select 2000
ocfs2-tools ocfs2-tools/idle_timeout seen true
ocfs2-tools ocfs2-tools/reconnect_delay seen true
ocfs2-tools ocfs2-tools/init seen true
ocfs2-tools ocfs2-tools/clustername seen true
ocfs2-tools ocfs2-tools/heartbeat_threshold seen true
ocfs2-tools ocfs2-tools/keepalive_delay seen true
EOF
