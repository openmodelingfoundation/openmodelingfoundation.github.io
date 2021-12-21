// GITHUB_EVENT_PATH always exists when run by an Action,
// see https://git.io/JvUf7 for a full list
// const eventPayload = require(process.env.GIHUB_EVENT_PATH);
const { Octokit } = require("@octokit/action");

listReactions();

async function listReactions() {

  // No need to pass process.env.GITHUB_TOKEN, `@octokit/action`
  // is using it directly and throws an error if it is not present.
  const octokit = new Octokit();

  // retrieve list of reactions on a comment on a pull request
  const { reactionData } = await octokit.request('GET /repos/{owner}/{repo}/pulls/comments/{comment_id}/reactions', {
    owner: 'openmodelingfoundation',
    repo: 'openmodelingfoundation.github.io',
    comment_id: 378
  });

  console.log('List of Reactions: ', reactionData);
}
