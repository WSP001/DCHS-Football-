// functions/export-rsvps-core.js
// Purpose: shared CSV generator for RSVP exports.

const { Buffer } = require("node:buffer");

// Replace with your real data source
async function fetchSubmissions() {
  // Example submission; swap for Netlify Forms API or storage reads
  return [
    { timestamp: new Date().toISOString(), name: "Jane Alumni", email: "jane@example.com", guests: 2 },
  ];
}

function toCsv(rows) {
  const header = ['timestamp', 'name', 'email', 'guests'];
  const lines = [header, ...rows.map(r => [r.timestamp, r.name, r.email, r.guests])];
  return lines.map(cols => cols.map(String).map(s => s.replace(/"/g, '""')).join(",")).join("\n");
}

async function generateExport() {
  const submissions = await fetchSubmissions();
  const csv = toCsv(submissions);
  const filename = `rsvp-export-${new Date().toISOString().slice(0,10)}.csv`;
  const bytes = Buffer.byteLength(csv);
  return { filename, csv, bytes, count: submissions.length };
}

module.exports = { generateExport };
