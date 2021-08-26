#!/bin/bash

tput setaf 3
echo '*** CONFIGURATION STARTED ***'
tput sgr0
echo
read -p "Select environment (type dev|prd): " environment

if [ "$environment" == "dev" ]; then
  ENVO="development"
elif [ "$environment" == "prd" ]; then
  ENVO="production"
else
  echo "  Environment is rejected"
  echo
  exit
fi

read -p "Select region (type 1|2): " region

if [ "$region" == "1" ]; then
  REGO="region1"
elif [ "$region" == "2" ]; then
  REGO="region2"
else
  echo "  Region is rejected"
  echo
  exit
fi

echo
tput setaf 1
echo '##########################################################################################'
echo "Region is $REGO"
echo "  RHACM Hub will be using $REGO folder under channels/ and observability/"
echo "Environment is $ENVO."
echo "  RHACM Hub will be watching branch $ENVO in the configured Git Repo"
echo
echo -n "Current Context: "
oc login -u system:admin > /dev/null
oc config current-context
tput setaf 1
echo '##########################################################################################'
tput sgr0

RANDO=`echo $RANDOM`

echo
read -p "Confirm details and user 'system:admin' (type $RANDO): " confirmation

if [ "$confirmation" == "$RANDO" ]; then
  echo "  Configuration is confirmed"
  echo
else
  echo "  Configuration is rejected"
  echo
  exit
fi

tput setaf 3
echo '*** CONFIGURATION COMPLETED ***'
tput sgr0
echo
echo
echo

tput setaf 3
echo '*** BOOTSTRAP STARTED ***'
tput sgr0
echo

tput setaf 2
echo 'Creating Namespaces, Secrets, and Channels'
tput sgr0
oc apply -f channels/$REGO/
echo

if [ -d "observability/$REGO/" ]; then
  tput setaf 2
  echo 'Creating Observability Addon'
  tput sgr0
  oc apply -f observability/$REGO/
  echo
else
  tput setaf 2
  echo 'Skipping Observability Addon'
  tput sgr0
  echo
fi

tput setaf 2
echo 'Creating Placement Rules and Bindings (Packages)'
tput sgr0
oc apply -k packages/subscriptions/$ENVO/
echo

tput setaf 2
echo 'Creating Subscriptions for Policy Subs'
tput sgr0
oc apply -f policies/sb-$ENVO.yaml
echo

tput setaf 3
echo '*** BOOTSTRAP COMPLETED ***'
tput sgr0
echo
