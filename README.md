# acm-policies

Kustomizable Policies and Channel/Subscription objects for Advanced Cluster Management.

## Creating new Policies

For each use case,
1. Create a unique usecase folder under policies/
2. Create a README.md file under the folder to explain the actions and purpose of the collection of policies.
3. Create a base folder for base files: policies, placement rules, and bindings.
4. Create an overlay folder with at least 1 overlay example on how to kustomize it.
5. Create subscription(s) for the overlay examples.


```
acm-policies
├── channel
│   ├── 01_namespace.yml
│   └── 02_channel.yml
├── policies
│   └── example
|       ├── USECASE.md
│       ├── base
│       │   ├── bindings.yml
│       │   ├── kustomization.yml
│       │   ├── placementrule.yml
│       │   └── policy-namespace-custom.yml
│       ├── overlays
│       │   ├── pets
│       │   │   ├── kustomization.yml
│       │   │   └── namespaces.yml
│       │   └── plants
│       │       ├── kustomization.yml
│       │       └── namespaces.yml
│       └── subscriptions
│           ├── sub-example-base.yml
│           ├── sub-example-pets.yml
│           └── sub-example-plants.yml
└── README.md

```

## Using Policies in ACM

1. Fork the project and update the channel and namespace yml to leverage your new endpoint.
2. Create an overlay in the same manner as the example overlay.
3. Create patches that tailor the policy to your environment.
4. Create a subscription using the new overlay.
5. Apply the channel and namespace to the hub cluster.
```
$ oc apply -f channel/
```
5. Apply the subscription to the hub cluster.
```
$ oc apply -f subscriptions/my-subscription.yml
```

