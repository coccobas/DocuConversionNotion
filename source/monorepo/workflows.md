# Worflows in monorepo

### worflow matrix


### How to force cancel the running worflow

1. Using gh auth, if you never login before, need to do 

    ```
    gh auth login
    ```

1. Find out the current running workflow id, please first check on github action page
   to make sure the current running one is the one you want to force cancel it
   (Because the "Cancel workflow" button on the page not always working)

    ```
    gh api --method GET /repos/BeagleSystems/monorepo/actions/runs --header 'Accept: application/vnd.github+json' --header "X-GitHub-Api-Version: 2022-11-28" | jq -r '.workflow_runs[] | select (.status == "queued") | .id'
    ```

    It should return the id as return

1. Fill the id to the line below and force cancel it instantly

    ```
    gh api --method POST /repos/BeagleSystems/monorepo/actions/runs/<workflow_id>/force-cancel --header 'Accept: application/vnd.github+json' --header "X-GitHub-Api-Version: 2022-11-28" | jq
    ```

    If it return "{}" then it should stopped

### How