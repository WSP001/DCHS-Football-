// netlify/functions/stats.js
// Simple dashboard stats API
exports.handler = async (event, context) => {
  // Handle CORS preflight
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET, OPTIONS'
      },
      body: ''
    };
  }

  try {
    // Simple mock data for now - will work immediately
    const mockData = {
      ok: true,
      counts: {
        'attending-yes': 12,
        'attending-no': 3,
        'attending-maybe': 8,
        'volunteer-ops': 5,
        'stage-crew': 2,
        'media-team': 4,
        'accessibility': 1,
        'vip-host': 3,
        'general-volunteer': 7,
        'recognition-team': 2,
        'sponsor-lead': 1,
        'auction-donor': 4,
        'special-diet': 2,
        'accessibility-needs': 1
      },
      last24: 5,
      last7d: 23,
      totalOpen: 55,
      latest: [
        {
          number: 1,
          title: 'Alumni Survey Submission - John Smith',
          labels: ['attending-yes', 'volunteer-ops'],
          url: 'https://github.com/WSP001/DCHS-Football-/issues/1',
          created_at: new Date().toISOString(),
          user: 'dchs-system'
        }
      ]
    };

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET, OPTIONS'
      },
      body: JSON.stringify(mockData)
    };

  } catch (error) {
    console.error('Stats function error:', error);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        error: 'Function error',
        message: error.message
      })
    };
  }
};
