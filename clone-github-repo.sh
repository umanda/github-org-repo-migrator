#!/bin/bash

echo "🔹 Enter the source organization (e.g., org-x):"
read ORIGIN_ORG

echo "🔹 Enter the target organization (e.g., org-y):"
read TARGET_ORG

echo "🔹 Use SSH or HTTPS? (Enter 'ssh' or 'https'):"
read CLONE_METHOD

if [[ "$CLONE_METHOD" != "ssh" && "$CLONE_METHOD" != "https" ]]; then
  echo "❌ Invalid clone method. Use 'ssh' or 'https'."
  exit 1
fi

echo "🔹 Do you want to clone all repos or selected repos only? (Enter 'all' or 'selected'):"
read REPO_CHOICE

REPOS=()

if [[ "$REPO_CHOICE" == "all" ]]; then
  echo "📦 Fetching all repositories from $ORIGIN_ORG..."
  mapfile -t REPOS < <(gh repo list "$ORIGIN_ORG" --limit 1000 --json name --jq '.[].name')
elif [[ "$REPO_CHOICE" == "selected" ]]; then
  echo "🔹 Enter full GitHub repo URLs (one per line). Press Ctrl+D when done:"
  while IFS= read -r repo_url; do
    repo_name=$(basename "$repo_url" .git)
    REPOS+=("$repo_name")
  done
else
  echo "❌ Invalid choice. Use 'all' or 'selected'."
  exit 1
fi

TEMP_DIR="temp_repos"
echo "📁 Creating temporary directory: $TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR" || exit 1

for repo in "${REPOS[@]}"; do
  echo ""
  echo "=========================================="
  echo "🔄 Processing repository: $repo"
  echo "=========================================="

  if [[ "$CLONE_METHOD" == "ssh" ]]; then
    CLONE_URL="git@github.com:$ORIGIN_ORG/$repo.git"
    PUSH_URL="git@github.com:$TARGET_ORG/$repo.git"
  else
    CLONE_URL="https://github.com/$ORIGIN_ORG/$repo.git"
    PUSH_URL="https://github.com/$TARGET_ORG/$repo.git"
  fi

  echo "🔁 Cloning $CLONE_URL..."
  git clone --mirror "$CLONE_URL"

  cd "$repo.git" || continue

  echo "📦 Creating repository $TARGET_ORG/$repo..."
  gh repo create "$TARGET_ORG/$repo" --private --confirm

  echo "🚀 Pushing to $TARGET_ORG..."
  git push --mirror "$PUSH_URL"

  cd ..
done

cd ..

echo ""
echo "🧼 Do you want to delete the temporary cloned repositories in '$TEMP_DIR'? (yes/no):"
read CLEANUP_CONFIRM

if [[ "$CLEANUP_CONFIRM" == "yes" || "$CLEANUP_CONFIRM" == "y" ]]; then
  echo "🗑️ Deleting temporary directory '$TEMP_DIR'..."
  rm -rf "$TEMP_DIR"
  echo "✅ Cleanup completed."
else
  echo "📁 Temporary directory '$TEMP_DIR' retained for your reference."
fi

echo "🎉 All repositories have been successfully migrated from $ORIGIN_ORG to $TARGET_ORG!"
