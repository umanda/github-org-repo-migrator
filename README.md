## 📦 GitHub Org Repo Migrator (via SSH or HTTPS)

Easily migrate or duplicate all repositories from one GitHub organization to another using SSH or HTTPS.
This Bash script is designed for engineers, DevOps, and org admins who want to bulk clone and push GitHub repositories from a **source org** to a **target org**, preserving all branches and tags using `git clone --mirror`.


### ✨ Features

* ✅ Interactive CLI prompts
* 🔄 Supports **SSH** or **HTTPS** cloning
* 📥 Clone all or select repositories
* 🔐 Preserves full Git history (branches + tags)
* 🧼 Optional cleanup of temporary files
* 📦 Works seamlessly with `gh` (GitHub CLI)


### 🔧 Requirements

* `bash`
* `git`
* [GitHub CLI (`gh`)](https://cli.github.com/) (must be authenticated)

  ```bash
  gh auth login
  ```
* `git` with SSH or HTTPS access configured
* Access to both source and target GitHub orgs


### 🚀 Usage

1. Clone this repo:

   ```bash
   git clone git@github.com:yourusername/github-org-repo-migrator.git
   cd github-org-repo-migrator
   ```

2. Make the script executable:

   ```bash
   chmod +x clone-github-repo.sh
   ```

3. Run the script:

   ```bash
   ./clone-github-repo.sh
   ```

4. Follow the interactive prompts:

   * Source organization
   * Target organization
   * SSH or HTTPS
   * Clone all or selected repositories
   * Cleanup confirmation


### 🛠 Example Workflow

```bash
./clone-github-repo.sh
```

```text
🔹 Enter the source organization (e.g., org-x):
org-x
🔹 Enter the target organization (e.g., org-y):
org-y
🔹 Use SSH or HTTPS? (Enter 'ssh' or 'https'):
ssh
🔹 Do you want to clone all repos or selected repos only? (Enter 'all' or 'selected'):
all
...
🧼 Do you want to delete the temporary cloned repositories in 'temp_repos'? (yes/no):
yes
```

### ⚠️ Notes

* `git clone --mirror` clones **all branches, tags, and refs**
* The script uses `gh repo create` to create new private repos in the target org
* You'll need proper permissions to both orgs for repo creation and cloning


### 📁 Directory Structure

```
github-org-repo-migrator/
├── clone-github-repo.sh   # Main executable script
└── README.md              # You're reading it!
└── LICENSE                # License infomation
└── .gitignore             # Let's not push all, this will help you to ignore unwanted files
```


### 📄 License

MIT License — feel free to fork, modify, and improve!


### 🙌 Acknowledgements

Built with 💻 for teams and org admins who love automation.
