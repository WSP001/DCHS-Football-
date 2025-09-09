// functions/export-rsvps-run.js
// Purpose: admin-invoked export using same core as scheduled job.
const { generateExport } = require("./export-rsvps-core");

function isAuthorized(event) {
  // Minimal guard — replace with your real auth (token, email allowlist, etc.)
  const token = process.env.ADMIN_EXPORT_TOKEN || "";
  const header = event.headers?.authorization || "";
  return token && header === `Bearer ${token}`;
}

exports.handler = async (event) => {
  try {
    if (event.httpMethod !== "POST") {
      return { statusCode: 405, body: "Use POST" };
    }
    if (!isAuthorized(event)) {
      return { statusCode: 401, body: "Unauthorized" };
    }

    const { filename, csv, bytes, count } = await generateExport();

    // Example: return CSV directly for download
    return {
      statusCode: 200,
      headers: {
        "Content-Type": "text/csv; charset=utf-8",
        "Content-Disposition": `attachment; filename="${filename}"`,
        "Cache-Control": "no-store",
      },
      body: csv,
    };
  } catch (err) {
    console.error("[run-now] export error:", err);
    return { statusCode: 500, body: "export failed" };
  }
};
