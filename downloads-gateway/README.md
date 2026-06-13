# Password-gated downloads — `downloads.jackbarker.com.au`

A standalone **Cloudflare Pages** project that serves the Architect Language
Tools download artifacts behind a single shared password (HTTP Basic Auth).

This folder is **not** part of the Jekyll site. It is excluded from the apex
build (`_config.yml` → `exclude: downloads-gateway`) and deploys separately
with `wrangler`. Keeping it in this repo just co-locates all website infra.

## Layout

```
downloads-gateway/
  wrangler.toml          Pages config (project name, output dir = public/)
  README.md              this file
  .gitignore             ignores the binary artifacts in public/
  public/                <-- the deployed folder
    _worker.js           Basic Auth gate (runs for every request)
    index.html           the download list
    architect-language-tools.vsix   (gitignored — copied in before deploy)
    architect-language-tools.zip    (gitignored — copied in before deploy)
```

The worker gates **every** path: `index.html` and the artifacts are only ever
returned via `env.ASSETS.fetch()`, which runs strictly after the password
check. There is no unauthenticated route.

## How auth works

- HTTP Basic Auth. The browser shows a username/password dialog.
- The **username is ignored** — only the password matters (single shared
  password model).
- The password is the **encrypted `DOWNLOAD_PASSWORD` secret**. It is never in
  `wrangler.toml`, never committed.
- Comparison is constant-time; if the secret is unset the worker **fails
  closed** (denies everyone) rather than serving the site open.

> Basic Auth has no per-user accounts, no revocation, and no logout (the
> browser caches the password until it's closed). If you later need audit logs
> or per-person revocation, switch to **Cloudflare Access** — no worker needed.

---

## One-time setup

Prerequisites: a Cloudflare account, `jackbarker.com.au` on Cloudflare DNS
(already the case), and Wrangler (`npm i -g wrangler`, or prefix every command
below with `npx`).

Run all commands from this `downloads-gateway/` directory.

### 1. Authenticate Wrangler

```bash
wrangler login
```

(Opens a browser to authorize. One-time per machine.)

### 2. Create the Pages project

```bash
wrangler pages project create jackbarker-downloads --production-branch main
```

### 3. Set the shared password (encrypted secret)

```bash
wrangler pages secret put DOWNLOAD_PASSWORD --project-name jackbarker-downloads
```

You'll be prompted to paste the password. Choose a long, random one — a single
shared password with no lockout is brute-forceable, so entropy is your defence.
**Never** add it to `wrangler.toml`.

### 4. First deploy

Copy the current artifacts in (see *Updating the files* below), then:

```bash
wrangler pages deploy --branch main
```

This reads `wrangler.toml`, uploads `public/`, and deploys.

> **Always pass `--branch main`.** The project's *production branch* is `main`,
> but this repo's git branch is `gh-pages`. Without `--branch main`, wrangler
> uses the current git branch (`gh-pages`) and publishes a **preview**
> deployment — the production URL and the custom domain would not update.

Open the production URL (`https://jackbarker-downloads.pages.dev/`): you should
get a password prompt, and the correct password reveals the download list. (Set
the secret in step 3 *before* deploying, or it fails closed with 401 for
everyone until the next deploy.)

### 5. Attach the custom domain

In the Cloudflare dashboard: **Workers & Pages → jackbarker-downloads →
Custom domains → Set up a custom domain →** `downloads.jackbarker.com.au`.

Because the zone's DNS is already on Cloudflare, this auto-creates the CNAME
and provisions the TLS certificate. Within a minute or two,
`https://downloads.jackbarker.com.au/` serves the gated page.

---

## Updating the files (every release)

The artifacts are **not** stored in git — they're copied fresh from the
`arch-lang-server` build output (`dist/`) right before each deploy. After
running the language-tools release (`RELEASE.md`), from this directory:

```bash
cp /mnt/c/Projects/arch-lang-server/dist/1-core/architect-language-tools.vsix public/architect-language-tools.vsix
cp /mnt/c/Projects/arch-lang-server/dist/5-to-ship.zip                          public/architect-language-tools.zip
wrangler pages deploy --branch main
```

(Paths assume the WSL view of the Windows build tree. The filenames served are
stable — the URLs never change across releases.) If a version label is shown
in `index.html` in future, bump it here too.

## Rotating the password

```bash
wrangler pages secret put DOWNLOAD_PASSWORD --project-name jackbarker-downloads
wrangler pages deploy --branch main   # <-- required: secret changes take effect on the next deploy
```

A secret change alone does **not** update the live production deployment — you
must redeploy for it to take hold.

## Local smoke test (optional)

`wrangler pages dev` reads bindings from a local **`.dev.vars`** file (NOT from
inline env vars), which is gitignored. Create one with a throwaway password:

```bash
echo 'DOWNLOAD_PASSWORD=smoketest-pw-123' > .dev.vars
wrangler pages dev public --port 8788
```

Then, in another shell:

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8788/                       # 401 (no creds)
curl -s -o /dev/null -w "%{http_code}\n" -u "x:smoketest-pw-123" http://127.0.0.1:8788/ # 200
```

Any username works (it's ignored); only the password is checked. Delete
`.dev.vars` when done.
