# Coding Style Guidelines

This document outlines the coding style guidelines for the TF-Cloudflare project.
Our goal is to maintain a consistent and readable codebase that can be easily managed and contributed to by the community.

## General Recommendations

- **Readability Over Conciseness**: Write code that is easy to read and understand. Avoid overly complex constructions.
- **Keep Up To Date**: Regularly update your code to use the latest versions of Terraform, providers, and any dependencies.
- **Review Pull Requests**: Encourage code reviews for all contributions to catch issues early and ensure adherence to the coding style.
- **Comments**:
    - **Clarity**: Write clear and concise comments that add value to the reader. Avoid vague or redundant comments.
    - **Maintainability**: Keep comments up to date with code changes. An outdated comment can be more misleading than no comment at all.
    - **Focus on Why**: Code tells you "how" it's done; comments should tell you "why" it's done that way.
    - **Use TODOs Wisely**: Use TODO: comments to mark placeholders and areas needing future attention, but ensure they are addressed in a timely manner.

## Bash Scripts

- **Shebang Line**: Always start your script with `#!/bin/bash` to indicate the script is a Bash script.
- **Variable Naming**: Use UPPER_CASE for environment variables and lower_case for local variables. Example: `LOCAL_VAR`, `GLOBAL_VAR`.
- **Conditionals**: Use `[[ ]]` for conditional expressions for better handling of strings and to avoid script errors.
- **Error Handling**: Use `set -o errexit` to make your script exit when a command fails.
- **Functions**: Use functions to modularize and reuse script sections. Function names should be descriptive and use snake_case.
- **Comments**:
    - **Header Comments**: Start each script with a comment block that describes its purpose, usage, and any expected arguments or environment variables.
    - **Inline Comments**: Use inline comments to explain "why" certain decisions were made, especially for non-obvious or complex logic.
    - **Function Descriptions**: Before each function, add comments that describe what the function does, its inputs, and outputs if applicable.
    - **Conditional Logic**: Comment on the branches of conditional statements to explain the criteria and outcomes.

## Terraform Code

- **Formatting**: Use `terraform fmt` to automatically format your Terraform code to adhere to the standard conventions.
- **Variable Naming**: Use snake_case for variable names and make them descriptive. Example: `instance_type`.
- **Resource Naming**: Use snake_case and prefix names with Terraform resource types. Example: `aws_instance.this`.
- **Modules**: Break down your configurations into modules for reusability and maintainability.
- **File Structure**: Organize your Terraform files by using separate files for variables (`variables.tf`), outputs (`outputs.tf`), and resources (`main.tf`, `network.tf`, etc.).
- **Comments**:
    - **Purpose of Configuration**: Comment on the purpose of the configuration or resource, especially when it's not immediately clear from the code itself.
    - **Complex Logic**: If your Terraform configuration involves complex logic or workarounds, explain why this approach was necessary.
    - **Resource Descriptions**: Add comments above each resource and module to describe its role within the infrastructure.
    - **Variable Descriptions**: Use the `description` field to explain the purpose of each variable and any expected values.
    - **Avoid Obvious Comments**: Don't comment on something that is already clear from the code (e.g., `# Create an AWS instance above an aws_instance resource`).

## Terratest Tests

- **Structure**: Organize your tests by mirroring the structure of your Terraform modules or components being tested.
- **Naming Conventions**: Test functions should be named descriptively to indicate what they are testing. Example: `TestInstanceType`.
- **Cleanup**: Ensure resources are cleaned up after tests run by using `defer` statements to destroy resources.
- **Error Handling**: Use Terratest modules' built-in error handling and avoid ignoring errors. Check for errors explicitly where needed.
- **Assertions**: Use the `assert` package for assertions to check the expected outcomes of your tests.
- **Parallel Execution**: Use `t.Parallel()` to mark tests that can be run in parallel. This can significantly speed up the test execution time.
- **Comments**:
    - **Test Descriptions**: At the beginning of each test function, use comments to describe what the test checks for and any specific conditions or configurations being tested.
    - **Setup and Teardown**: Comment on the setup and teardown logic to explain any resources being created or destroyed and why they are necessary for the test.
    - **Assert Explanations**: When using assertions, briefly comment on the expected outcome to clarify the purpose of the assertion.

Remember, good comments don't just repeat what the code does; they offer insights into the design and decision-making process behind the code.

We encourage all contributors to follow these guidelines to help maintain the quality and consistency of the project's codebase.