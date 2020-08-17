#!/usr/bin/python
import sys
import requests
import json

if len(sys.argv) != 2:
  print("Script takes one argument and one argument only")
  sys.exit()

access_token = str(sys.argv[1])
org_name = "HymnalDreamTeam"
repo_name = "Hymns-iOS"

page = 1
done = False
all_artifacts = []

# find artifacts to delete
while not done:

  # Deprecated but still seems to work for now. Keeping it in case. Will delete once it is removed from the api
  # https://developer.github.com/changes/2020-02-10-deprecating-auth-through-query-param/
  # output = json.loads(requests.get("https://api.github.com/repos/" + org_name + "/" + repo_name + "/actions/artifacts?access_token=" + access_token + "&page=" + str(page)).text)

  output = json.loads(requests.get("https://api.github.com/repos/" + org_name + "/" + repo_name + "/actions/artifacts?page=" + str(page), headers={"Authorization": "token " + access_token}).text)

  page += 1
  total_count = output["total_count"]

  if total_count == 0:
    print(org_name + "/" + repo_name + " has no artifacts to delete")
    sys.exit()

  all_artifacts = all_artifacts + output["artifacts"]

  if len(all_artifacts) >= total_count:
    done = True

print("Amount of artifacts for repo " + repo_name + " is " + str(len(all_artifacts)))

# delete the artifacts
for artifact in all_artifacts:
  artifact_id = artifact["id"]
  name = artifact["name"]
  size = artifact["size_in_bytes"]
  delete_url = "https://api.github.com/repos/" + org_name + "/" + repo_name + "/actions/artifacts/" + str(artifact_id) + "?access_token=" + access_token
  response_code = requests.delete(delete_url, headers={"Authorization": "token " + access_token}).status_code

  if response_code == 204:
    print("Repo: " + repo_name + " | Artifact with id " + str(artifact_id) + " and name " + name + " and size " + str(size) + "bytes has been deleted")
  else:
    print("Repo: " + repo_name + " | Something went wrong while deleting artifact with id " + str(artifact_id))
