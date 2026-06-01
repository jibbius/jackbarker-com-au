/**
 * Cloudflare Pages advanced-mode Worker.
 *
 * Gates EVERY request to downloads.jackbarker.com.au behind HTTP Basic Auth.
 * A single shared password is read from the encrypted `DOWNLOAD_PASSWORD`
 * secret (set with `wrangler pages secret put DOWNLOAD_PASSWORD` — never in
 * wrangler.toml [vars], never committed). The username is ignored.
 *
 * Because this file is `_worker.js`, Pages runs it for every path and the
 * `functions/` directory (if any) is ignored. Static assets — index.html and
 * the download artifacts — are only ever returned via `env.ASSETS.fetch()`,
 * which we call strictly AFTER the auth check passes, so no path is reachable
 * unauthenticated.
 */

const REALM = 'JackBarker.com.au downloads';

export default {
  async fetch(request, env) {
    if (!isAuthorized(request, env.DOWNLOAD_PASSWORD)) {
      return new Response('Authentication required.\n', {
        status: 401,
        headers: {
          // Prompt the browser's Basic Auth dialog.
          'WWW-Authenticate': `Basic realm="${REALM}", charset="UTF-8"`,
          'Cache-Control': 'no-store',
          'Content-Type': 'text/plain; charset=UTF-8',
        },
      });
    }

    // Authorized — serve the requested static asset.
    return env.ASSETS.fetch(request);
  },
};

/**
 * @param {Request} request
 * @param {string|undefined} expected  The shared password (DOWNLOAD_PASSWORD secret).
 * @returns {boolean}
 */
function isAuthorized(request, expected) {
  // Fail closed: if the secret was never set, deny everyone rather than
  // accidentally serving the site wide open.
  if (!expected) return false;

  const header = request.headers.get('Authorization') || '';
  const [scheme, encoded] = header.split(' ');
  if (scheme !== 'Basic' || !encoded) return false;

  let decoded;
  try {
    decoded = atob(encoded);
  } catch {
    return false; // malformed base64
  }

  // "username:password" — the username is ignored (single shared password).
  const sep = decoded.indexOf(':');
  if (sep === -1) return false;
  const supplied = decoded.slice(sep + 1);

  return timingSafeEqual(supplied, expected);
}

/**
 * Constant-time string comparison. `crypto.subtle.timingSafeEqual` requires
 * equal-length buffers, so a length mismatch short-circuits to false (this
 * leaks only the password's length, which is acceptable here).
 */
function timingSafeEqual(a, b) {
  const enc = new TextEncoder();
  const ab = enc.encode(a);
  const bb = enc.encode(b);
  if (ab.byteLength !== bb.byteLength) return false;
  return crypto.subtle.timingSafeEqual(ab, bb);
}
