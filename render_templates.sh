#!/bin/bash

DCO_PCOMMIT_CONFIG=".pre-commit-dco-config.yaml"

function run_py27(){
  echo "Running python2.7 version of the render-templates hook..."
  pre-commit run render-templates -c .pre-commit-dco-config.yaml --all-files
}

function run_py3(){
  echo "Running python3 version of the render-templates hook..."
  pre-commit run render-templates3 -c .pre-commit-dco-config.yaml --all-files
}

function has() {
  curl -sL https://git.io/_has | bash -s $1
  return $?
}

# Update hooks because the are "fast changing"
pre-commit autoupdate -c .pre-commit-dco-config.yaml 

# Convert "dco.ods" file to YAML files
pre-commit run ods-to-yaml -c "$DCO_PCOMMIT_CONFIG" --all-files 

# Execute the template renderer, for python2.7 (RHEL7, RHEL7 CSB)
if [ -f /etc/os-release ]; then
  #RHEL or Fedora system.
  source /etc/os-release
  if [ "$ID" == "rhel" ]; then
    if [ "${VERSION_ID:0:1}" == "7" ]; then
        run_py27
    else
        run_py3
    fi
  else
    run_py3
  fi

else
  echo "Could not find /etc/os-release file!"
  echo "Relying on available Python interpreters"

  has "python" && HAS_PYTHON2=1
  has "python3" && HAS_PYTHON3=1
  
  if [[ $HAS_PYTHON3 -eq 1 ]]; then
     run_py3
  elif [[ $HAS_PYTHON2 -eq 1 ]]; then 
    run_py27
  else
    echo "Unable to find any Python interpreter!"
    exit 3
  fi
fi

# Last (optional) step: apply hooks to ensure generated files comply with DB
# Those hooks update files, so we can't rely on the exitcode nor run them in one step.
pre-commit run xmlformat -a 2>&1
pre-commit run pattern-replacer -a 2>&1
