# example

Policy to demonstrate a basic Configuration Policy with Kustomize and setup for GitOps. The policy will enforce the creation or deletion of namespaces in the managed clusters. The selectors only pick clusters that are operational and in the AWS cloud.

The overlays customize the policy by adding namespaces in line with the themes of pets and plants.

```
example/
├── base
│   ├── bindings.yml
│   ├── kustomization.yml
│   ├── placementrule.yml
│   └── policy-namespace-custom.yml
├── overlays
│   ├── pets
│   │   ├── kustomization.yml
│   │   └── namespaces.yml
│   └── plants
│       ├── kustomization.yml
│       └── namespaces.yml
├── subscriptions
│   ├── sub-example-base.yml
│   ├── sub-example-pets.yml
│   └── sub-example-plants.yml
└── USECASE.md
```



