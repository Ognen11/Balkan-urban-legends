import { execFileSync } from "node:child_process";
import { readFileSync, writeFileSync } from "node:fs";

const git = (...args) => execFileSync("git", args, { encoding: "utf8" }).trimEnd();
const escape = text => text.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
const paths = ["--", ".", ":(exclude).github/**", ":(exclude,icase)readme.md", ":(exclude).gitignore", ":(exclude).gitattributes"];
const commits = git("rev-list", "--first-parent", "--min-parents=1", "HEAD").split("\n").filter(Boolean);
const entries = [];
for (const commit of commits) {
  const fields = git("diff", "--name-status", "--no-renames", "-z", commit + "^1", commit, ...paths).split("\0");
  if (!fields[0]) continue;
  const labels = { A: "Added", D: "Removed", M: "Modified", T: "Changed type" };
  const lines = [];
  for (let i = 0; i + 1 < fields.length; i += 2) {
    lines.push((labels[fields[i]] ?? fields[i]) + "  " + escape(fields[i + 1]));
  }
  const title = escape(git("show", "-s", "--format=%s", commit));
  entries.push('<details><summary>' + title + '</summary>\n\n[View commit](https://github.com/Ognen11/Balkan-urban-legends/commit/' + commit + ')\n\n<pre>' + lines.join("\n") + '</pre>\n</details>');
  if (entries.length === 10) break;
}
const marker = "<!-- game-changes -->";
const readme = readFileSync("README.md", "utf8");
if (!readme.includes(marker)) throw new Error("Missing game changes marker in README.md");
writeFileSync("README.md", readme.split(marker)[0] + marker + "\n\n" + entries.join("\n\n") + "\n");
