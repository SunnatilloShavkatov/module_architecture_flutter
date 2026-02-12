# Module Selection (Feature Ownership)

This document defines how to choose the correct module for a new AI task.

## 1. Goal

Before writing code, identify a single owner module.

- if owner exists -> implement in that module;
- if owner does not exist -> create a new module.

## 2. Selection Algorithm

1. classify feature domain and business responsibility;
2. match with existing modules;
3. check where similar entities/use cases/pages already live;
4. choose one owner module.

If no clear owner exists after step 4, create a new module.

## 3. Current Module Ownership Map

- `modules/auth` -> authentication and session flows
- `modules/home` -> home/dashboard content
- `modules/initial` -> startup/welcome/splash
- `modules/main` -> app shell, tab/root flow
- `modules/more` -> settings and more menu
- `modules/system` -> not found/no internet/system screens

## 4. Create-New-Module Trigger

Create a new module when all are true:

- feature introduces a new bounded context;
- it has independent routes/pages/use cases;
- it does not naturally fit existing module ownership;
- adding it to an existing module would increase coupling.

Then follow:

- `docs/architecture/new_module_creation.md`

## 5. Cross-Module Rule

If feature touches multiple modules:

- keep one owner module;
- other modules interact through navigation or explicit interfaces;
- do not duplicate business logic in multiple modules.

## 6. Required Output in AI Work

Before implementation, AI should make an explicit decision:

- `Owner module: <module_name>`
- `Reason: <short ownership reason>`
- `New module required: yes/no`

After implementation, AI should also provide:

- `Touched files: <changed files list>`
