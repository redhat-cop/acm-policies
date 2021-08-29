# acm-policies

A proposed project layout for GitOps-managed policies in Red Hat Advanced Cluster Management (RHACM).

This project covers configurations commonly found in consulting engagements per Red Hat Consulting's best practices or policies required to satisfy security standards such as HIPAA.

There are also other security standard policies found in the upstream project (Open Cluster Management) called [policy-collection](https://github.com/open-cluster-management/policy-collection). The product team will periodically check here for useful policies.

Please do not use this repository as your GitOps endpoint. Clone or fork the repo.

---

## Project Directories

There are four directories to provide the channel credentials, observability credentials, policy groupings and the policies themselves.

### Channels Directory
```
channels/
└── region1
    ├── 01_namespace.yaml
    ├── 02_accounts.yaml
    ├── 03_git_certca.yaml
    ├── 03_git_creds.yaml
    ├── 03_s3_creds.yaml
    └── 04_channels.yaml
```

Channels directory contains folders that represent an area that is managed under a single instance of RHACM. This repository provides an example "region1" for your convenience, but you should rename it and replace the values with something useful.

The namespace is where the Channel and Secret (credentials and certificates) objects are kept. Other objects such as the Subscriptions that watch for changes will be placed here.

The account binds the system:admin user to the role 'open-cluster-management:subscription-admin'. As of right now, only the system:admin is functional enough to execute subscription-admin actions. This is being addressed in JIRA.

The git definitions are for TLS verification and git authentication. The same goes for the s3 definition. These are for the source repositories for the policies.

The channel defines the source repository.

<br/>
<b>Note: channels/ is listed in the gitignore file so that users do not accidentally upload their secrets.</b>


### Observability Directory
```
observability/
└── region1
    ├── 01_namespace.yaml
    ├── 02_objstrcreds.yaml
    ├── 02_pullsecret.yaml
    ├── 03_observability.yaml
    ├── 04_custom-metrics.yaml
    └── 05_custom-dashboard.yaml
```

Observability directory contains folders that represent an area that is managed under a single instance of RHACM. This area name should match the name found under the channel directory.

The namespace contains the observability operator, deployments, secrets and configurations. Use the default name.

The objstrcreds defines will thanos will store the raw metrics collected from the managed clusters.

The pullsecret lets us pull the observability images.

The custom-metrics is a ConfigMap that allows us to include or exclude a list of metrics collected at the hub.

The custom-dashboard is a ConfigMap that contains the json definition of a custom grafana dashboard. 

<br/>
<b>Note: observability/ is listed in the gitignore file so that users do not accidentally upload their secrets.</b>


### Packages Directory
```
packages/
├── boms
│   ├── acm-addons
│   │   ├── 01_namespace.yaml
│   │   ├── 02_pr-serverless.yaml
│   │   └── 03_pb-serverless.yaml
│   ├── acm-hipaa
│   │   ├── 01_namespace.yaml
│   │   ├── 02_pr-hipaa.yaml
│   │   └── 03_pb-hipaa.yaml
│   └── acm-sandbox
│       ├── 01_namespace.yaml
│       ├── 02_pr-sandbox.yaml
│       └── 03_pb-sandbox.yaml
└── subscriptions
    ├── base
    │   ├── kustomization.yaml
    │   └── sb-boms.yaml
    ├── development
    │   └── kustomization.yaml
    └── production
        └── kustomization.yaml
```

Packages directory contains two folders: boms and subscriptions.

Boms is short for bill-of-materials. Each folder under boms represents a collection or grouping of policies, placementbindings, and placementrules. These objects live in the same namespace. In this repo, we have a bom for cluster addon features, a bom for hipaa compliance policies, and a bom for the sandbox policies.

Subscriptions contain the subscription that will keep the boms folder under GitOps watch. That means that any additional collections created under the boms folder will be pulled into RHACM.

The subscription has also been kustomized so that different git branches branches and reconcile-rates can be used for different environment deployments. Development and production environments are defined as examples.

### Policies Directory
```
policies/
├── policy-default-ingress-cert
│   ├── base
│   │   ├── kustomization.yaml
│   │   └── pl-default-ingress-cert.yaml
│   └── sandbox
│       └── kustomization.yaml
├── policy-disable-schedule-control
│   ├── base
│   │   ├── kustomization.yaml
│   │   └── pl-disable-schedule-control.yaml
│   └── sandbox
│       └── kustomization.yaml
├── policy-serverless
│   ├── base
│   │   ├── kustomization.yaml
│   │   └── pl-serverless.yaml
│   └── sandbox
│       └── kustomization.yaml
├── sb-development.yaml
├── sb-production.yaml
└── subscriptions
    ├── base
    │   ├── kustomization.yaml
    │   ├── sb-default-ingress-cert.yaml
    │   ├── sb-disable-schedule-control.yaml
    │   └── sb-serverless.yaml
    ├── development
    │   └── kustomization.yaml
    └── production
        └── kustomization.yaml
```

Policies directory contain all the policies and policy variations as well as the subscriptions that assign them to one or more boms.

Each policy folder contains a base folder and more variation folders (commonly referred to as overlays). Kustomize allows changes to base policy using naming ammendments, common annotations, and patches. It is convenient, but is not required. It is entirely possible to have a bunch of separate base folders containing a unique version of the policy.

Subscriptions for policies are responsible for watching the correct folder (ie, the correct policy variant) and writing the policy in the correct bom namespace. This is why the policies themselves do not define a namespace. It is expected that the subscription will override it. The end effect is that both the subscription and the policy will end up in the same namespace.

If a policy version is intended for multiple locations, then multiple subscriptions must be defined. This could all be done in a single manifest yaml, but we have broken the manifests into one yaml per policy. Separate the definitions by the document delimiter (three dashes).

In order for us to continue serving different environments in our GitOps model, we kustomize the subscriptions to pull from the correct git-branch. We can also choose to change its reconcile-rate.

Lastly, we use a subscription of subscriptions model to keep all subscriptions/polices under watch. That is what the sb-development and sb-production yamls are for.

