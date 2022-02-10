# Project Creation Checklist
Congratulations on creating a new Moore.io-based UVM Agent!  Please ensure the following is completed before starting to add IP to the repo:
- [ ] Replace `${name}` and `${full_name}` in the codebase.  Ex: `pcie` and `PCI Express`
- [ ] Review the list of external libraries in `/sim/setup_project.py`
- [ ] Review the project variables in `/sim/setup_terminal.sh`
- [ ] Add an image for the project logo in the `gh-pages` branch, under `/assets/img/logo.png`
- [ ] Add a block diagram for the Agent in the `gh-pages` branch, under `/assets/img/agent_block_diagram.svg`


# About
## [Home Page](https://datum-technology-corporation.github.io/uvma_${name}/)
The [Moore.io](https://www.mooreio.com) ${full_name} Agent is a pure-UVM, Sequence-based implementation of the open standard that can act as either an active Agent or purely passive monitor.
This project consists of the Agent (`uvma_${name}_pkg`), the self-testing UVM Environment (`uvme_${name}_st_pkg`) and the Test Bench (`uvmt_${name}_st_pkg`) to verify the Agent against itself.

## IP
* DV
> * uvma_${name}
> * uvme_${name}_st
> * uvmt_${name}_st
* RTL
* Tools


# Simulation
**1. Change directory to 'sim'**

This is from where all jobs will be launched.
```
cd ./sim
```

**2. Project Setup**

Only needs to be done once, or when libraries must be updated. This will pull in dependencies from the web.
```
./setup_project.py
```

**3. Terminal Setup**

This must be done per terminal. The script included in this project is for bash:

```
export VIVADO=/path/to/vivado/bin # Set locaton of Vivado installation
source ./setup_terminal.sh
```

**4. Launch**

All jobs for simulation are performed via `mio`.

> At any time, you can invoke its built-in documentation:

```
mio --help
```

> To run test 'all_access' with seed '1' and wave capture enabled:

```
clear && mio all uvmt_${name}_st -t all_access -s 1 -w
```
