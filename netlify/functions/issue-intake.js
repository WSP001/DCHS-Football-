// netlify/functions/issue-intake.js
// Creates a GitHub Issue from Netlify Form submissions.
// Env vars required: GITHUB_TOKEN, GH_OWNER, GH_REPO
// Optional: ISSUE_DEFAULT_ASSIGNEES (comma list), WEBHOOK_SECRET (to verify header)

export const handler = async (event) => {
  try {
    // Only POST allowed
    if (event.httpMethod !== "POST") {
      return resp(405, { error: "Method Not Allowed" });
    }

    // Optional shared-secret verification (if you add header in Netlify Webhook)
    const secret = process.env.WEBHOOK_SECRET || "";
    if (secret) {
      const given = event.headers["x-webhook-secret"] || event.headers["X-Webhook-Secret"];
      if (given !== secret) return resp(401, { error: "Unauthorized" });
    }

    // Parse incoming payload from Netlify webhook OR netlify dev curl
    const payload = JSON.parse(event.body || "{}");

    // Netlify sends { payload: {...} } for some sources; normalize
    const root = payload.payload || payload || {};
    const data =
      root.data ||
      root.body ||
      root || {};

    // Form name (optional, for routing)
    const formName = root.form_name || root.formName || root.form || "unknown-form";

    // Extract fields (be forgiving with key names)
    const get = (...keys) => {
      for (const k of keys) {
        if (data[k] != null && ${data[k]}.length) return String(data[k]).trim();
      }
      return "";
    };

    const name       = get("name", "full_name");
    const email      = get("email");
    const mobile     = get("mobile", "phone");
    const classYear  = get("class_year", "classYear", "year");
    const role       = get("role");
    const attending  = get("attending");
    const guests     = get("guests", "guest_count", "plus_ones");
    const decade     = get("decade");
    const accessDiet = get("access_diet", "accessibility", "dietary");
    const memory     = get("memory", "story", "notes");
    const photoUrl   = get("photo_url", "photo", "image");

    // Volunteer interest checkboxes (value "1" or "on")
    const asBool = (v) => v === "1" || v === "on" || v === "true" || v === true;
    const volunteer = {
      checkin:     asBool(get("volunteer_checkin")),
      auction:     asBool(get("volunteer_auction")),
      stage:       asBool(get("volunteer_stage")),
      media:       asBool(get("volunteer_media")),
      access:      asBool(get("volunteer_access")),
      vip:         asBool(get("volunteer_vip")),
      any:         asBool(get("volunteer_any")),
    };

    const recognitionTeam = asBool(get("recognition_team"));
    const sponsorInterest = asBool(get("sponsor_interest"));

    // Labels mapping
    const labels = new Set();

    if ((attending || "").toLowerCase() === "yes")     labels.add("attending-yes");
    if (volunteer.checkin || volunteer.any)            labels.add("volunteer-ops");
    if (volunteer.auction || sponsorInterest)          labels.add("auction-donor");
    if (volunteer.stage || volunteer.any)              labels.add("stage-crew");
    if (volunteer.media || volunteer.any)              labels.add("media-team");
    if (volunteer.access || volunteer.any)             labels.add("accessibility");
    if (volunteer.vip)                                 labels.add("vip-host");
    if (volunteer.any)                                 labels.add("general-volunteer");
    if (recognitionTeam)                               labels.add("recognition-team");
    if (sponsorInterest)                               labels.add("sponsor-lead");

    // Build issue title/body
    const safe = (s) => (s || "").replace(/\r/g, "").trim();

    const title = RSVP:  () — ;

    const lines = [
      **Form:** ,
      **Name:** ,
      **Email:** ,
      **Mobile:** ,
      **Class Year:** ,
      **Role:** ,
      **Attending:**  (Guests: ),
      **Decade Table:** ,
      **Accessibility/Dietary:** ,
      recognitionTeam ? **Program & Recognition Team:** Yes : **Program & Recognition Team:** No,
      sponsorInterest ? **Sponsorship Interest:** Yes : **Sponsorship Interest:** No,
      volunteer.checkin ? - Volunteer: Check-In & Badges : null,
      volunteer.auction ? - Volunteer: Auction Table : null,
      volunteer.stage ? - Volunteer: Stage Crew & Timing : null,
      volunteer.media ? - Volunteer: Social/Photo/Media : null,
      volunteer.access ? - Volunteer: Accessibility Concierge : null,
      volunteer.vip ? - Volunteer: VIP Host : null,
      volunteer.any ? - Volunteer: Wherever needed : null,
      memory ? \n**Memory/Story**\n\n : null,
      photoUrl ? \n**Photo URL**\n\n : null,
    ].filter(Boolean);

    const body = lines.join("\n");

    // GitHub API call
    const token = process.env.GITHUB_TOKEN;
    const owner = process.env.GH_OWNER;
    const repo  = process.env.GH_REPO;
    if (!token || !owner || !repo) {
      return resp(500, { error: "Server not configured (GITHUB_TOKEN, GH_OWNER, GH_REPO required)" });
    }

    const assignees = (process.env.ISSUE_DEFAULT_ASSIGNEES || "")
      .split(",")
      .map(s => s.trim())
      .filter(Boolean);

    const res = await fetch(https://api.github.com/repos///issues, {
      method: "POST",
      headers: {
        "Authorization": Bearer ,
        "Accept": "application/vnd.github+json",
        "Content-Type": "application/json",
        "X-GitHub-Api-Version": "2022-11-28"
      },
      body: JSON.stringify({
        title,
        body,
        labels: Array.from(labels),
        assignees: assignees.length ? assignees : undefined
      })
    });

    if (!res.ok) {
      const txt = await res.text();
      return resp(res.status, { error: "GitHub API error", details: txt });
    }

    const issue = await res.json();
    return resp(201, { ok: true, number: issue.number, html_url: issue.html_url });

  } catch (err) {
    return resp(500, { error: "Unhandled error", details: String(err) });
  }
};

function resp(statusCode, json) {
  return {
    statusCode,
    headers: { "Content-Type": "application/json; charset=utf-8" },
    body: JSON.stringify(json, null, 2)
  };
}
