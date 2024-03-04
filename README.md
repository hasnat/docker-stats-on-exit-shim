# Docker Stats On Exit Shim

[![Build Status](https://travis-ci.org/delcypher/docker-stats-on-exit-shim.svg?branch=master)](https://travis-ci.org/delcypher/docker-stats-on-exit-shim)

This is a small utility designed to capture the statistics for the run of a Docker
container before its destruction.

It is designed to be used as the main process of a Docker container that wraps the
real command by waiting for it to exit and then querying the active Cgroup subsystems
to gather their statistics. It dumps these statistics to a file as JSON and then exits
with the exit code of the real command.

## Environment variables
- `STATS_OUTPUT_FILE=/dev/stdout` file path you want your output to be saved to (Default /dev/stdout)
- `STATS_OUTPUT_PREFIX=` any prefix you want to add before stats output (Default blank)


## Example
Dockerfile
```
COPY --from=hasnat/docker-stats-on-exit-shim /docker-stats-on-exit-shim .
ENTRYPOINT ["/docker-stats-on-exit-shim"]
CMD ["sleep", "1"]
```
Example Run
```bash
$ docker run --rm -ti hasnat/docker-stats-on-exit-shim:exitgo /bin/sleep 1
```
Output example
```json
{"cgroup.controllers":"cpuset cpu io memory hugetlb pids rdma","cgroup.events.populated":"1","cgroup.events.frozen":"0","cgroup.freeze":"0","cgroup.kill":"","cgroup.max.depth":"max","cgroup.max.descendants":"max","cgroup.procs":"1","cgroup.procs":"67","cgroup.procs":"68","cgroup.stat.nr_descendants":"0","cgroup.stat.nr_dying_descendants":"0","cgroup.subtree_control":"","cgroup.threads":"1","cgroup.threads":"109","cgroup.threads":"110","cgroup.type":"domain","cpu.idle":"0","cpu.max.max":"100000","cpu.max.burst":"0","cpu.stat.usage_usec":"112557","cpu.stat.user_usec":"8732","cpu.stat.system_usec":"103824","cpu.stat.nr_periods":"0","cpu.stat.nr_throttled":"0","cpu.stat.throttled_usec":"0","cpu.stat.nr_bursts":"0","cpu.stat.burst_usec":"0","cpu.stat.local.throttled_usec":"0","cpu.weight":"100","cpu.weight.nice":"0","cpuset.cpus":"","cpuset.cpus.effective":"0-9","cpuset.cpus.partition":"member","cpuset.mems":"","cpuset.mems.effective":"0","hugetlb.1GB.current":"0","hugetlb.1GB.events.max":"0","hugetlb.1GB.events.local.max":"0","hugetlb.1GB.max":"max","hugetlb.1GB.numa_stat.total=0":"N0=0","hugetlb.1GB.rsvd.current":"0","hugetlb.1GB.rsvd.max":"max","hugetlb.2MB.current":"0","hugetlb.2MB.events.max":"0","hugetlb.2MB.events.local.max":"0","hugetlb.2MB.max":"max","hugetlb.2MB.numa_stat.total=0":"N0=0","hugetlb.2MB.rsvd.current":"0","hugetlb.2MB.rsvd.max":"max","hugetlb.32MB.current":"0","hugetlb.32MB.events.max":"0","hugetlb.32MB.events.local.max":"0","hugetlb.32MB.max":"max","hugetlb.32MB.numa_stat.total=0":"N0=0","hugetlb.32MB.rsvd.current":"0","hugetlb.32MB.rsvd.max":"max","hugetlb.64KB.current":"0","hugetlb.64KB.events.max":"0","hugetlb.64KB.events.local.max":"0","hugetlb.64KB.max":"max","hugetlb.64KB.numa_stat.total=0":"N0=0","hugetlb.64KB.rsvd.current":"0","hugetlb.64KB.rsvd.max":"max","io.stat":"254:0 rbytes=798720 wbytes=0 rios=50 wios=0 dbytes=0 dios=0","memory.current":"6676480","memory.events.low":"0","memory.events.high":"0","memory.events.max":"0","memory.events.oom":"0","memory.events.oom_kill":"0","memory.events.oom_group_kill":"0","memory.events.local.low":"0","memory.events.local.high":"0","memory.events.local.max":"0","memory.events.local.oom":"0","memory.events.local.oom_kill":"0","memory.events.local.oom_group_kill":"0","memory.high":"max","memory.low":"0","memory.max":"max","memory.min":"0","memory.oom.group":"0","memory.peak":"8974336","memory.reclaim":"","memory.stat.anon":"516096","memory.stat.file":"798720","memory.stat.kernel":"3772416","memory.stat.kernel_stack":"49152","memory.stat.pagetables":"114688","memory.stat.sec_pagetables":"0","memory.stat.percpu":"25440","memory.stat.sock":"0","memory.stat.vmalloc":"0","memory.stat.shmem":"0","memory.stat.zswap":"0","memory.stat.zswapped":"0","memory.stat.file_mapped":"0","memory.stat.file_dirty":"0","memory.stat.file_writeback":"0","memory.stat.swapcached":"0","memory.stat.anon_thp":"0","memory.stat.file_thp":"0","memory.stat.shmem_thp":"0","memory.stat.inactive_anon":"0","memory.stat.active_anon":"475136","memory.stat.inactive_file":"225280","memory.stat.active_file":"573440","memory.stat.unevictable":"0","memory.stat.slab_reclaimable":"251352","memory.stat.slab_unreclaimable":"603608","memory.stat.slab":"854960","memory.stat.workingset_refault_anon":"0","memory.stat.workingset_refault_file":"0","memory.stat.workingset_activate_anon":"0","memory.stat.workingset_activate_file":"0","memory.stat.workingset_restore_anon":"0","memory.stat.workingset_restore_file":"0","memory.stat.workingset_nodereclaim":"0","memory.stat.pgscan":"0","memory.stat.pgsteal":"0","memory.stat.pgscan_kswapd":"0","memory.stat.pgscan_direct":"0","memory.stat.pgscan_khugepaged":"0","memory.stat.pgsteal_kswapd":"0","memory.stat.pgsteal_direct":"0","memory.stat.pgsteal_khugepaged":"0","memory.stat.pgfault":"112536","memory.stat.pgmajfault":"7","memory.stat.pgrefill":"0","memory.stat.pgactivate":"0","memory.stat.pgdeactivate":"0","memory.stat.pglazyfree":"0","memory.stat.pglazyfreed":"0","memory.stat.zswpin":"0","memory.stat.zswpout":"0","memory.stat.thp_fault_alloc":"1","memory.stat.thp_collapse_alloc":"0","memory.swap.current":"0","memory.swap.events.high":"0","memory.swap.events.max":"0","memory.swap.events.fail":"0","memory.swap.high":"max","memory.swap.max":"max","memory.swap.peak":"0","memory.zswap.current":"0","memory.zswap.max":"max","pids.current":"3","pids.events.max":"0","pids.max":"max","pids.peak":"6","rdma.current":"","rdma.max":"","":""}

```

## Building

```bash
docker build -t docker-stats-on-exit-shim .
```

## Caveats

* The recorded statistics won't quite be before container destruction but it's probably close enough.
* The recorded statistics will contain the run of the tool (i.e. it will contribute to CPU usage). It should
  be a very small contribution though.
* I did't read cgroups docs yet. I just used the `cat` command to get all/any stats. I will update the code once I read the docs.