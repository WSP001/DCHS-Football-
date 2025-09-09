// functions/export-rsvps-scheduled.js
const { generateExport } = require("./export-rsvps-core");

exports.handler = async () => {
  try {
    const { filename, csv, bytes, count } = await generateExport();
    // TODO: persist CSV (S3/Git/email) using env creds
    console.log(`[scheduled] generated ${filename} (${bytes} bytes, rows=${count})`);
    return { statusCode: 200, body: JSON.stringify({ ok: true, file: filename, bytes, rows: count }) };
  } catch (err) {
    console.error("[scheduled] export error:", err);
    return { statusCode: 500, body: "export failed" };
  }
};

exports.config = { schedule: "@daily" };
