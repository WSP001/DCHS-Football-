// netlify/edge-functions/headers.ts
// Purpose: Enterprise-grade security & cache headers for dchs-football.org reunion site

export default async (request: Request) => {
  // Fetch the origin response first
  const originResponse = await fetch(request);
  
  // Clone and harden headers
  const res = new Response(originResponse.body, originResponse);
  
  // Security headers for reunion site protection
  res.headers.set("Strict-Transport-Security", "max-age=63072000; includeSubDomains; preload");
  res.headers.set("X-Content-Type-Options", "nosniff");
  res.headers.set("X-Frame-Options", "SAMEORIGIN");
  res.headers.set("Referrer-Policy", "strict-origin-when-cross-origin");
  res.headers.set("Permissions-Policy", 
    "geolocation=(), microphone=(), camera=(), payment=(), usb=(), interest-cohort=()");
  
  // Optimize caching for reunion assets
  const url = new URL(request.url);
  if (url.pathname.includes('/assets/') || url.pathname.includes('/alumni-photos/')) {
    // Long cache for static reunion photos and assets
    res.headers.set("Cache-Control", "public, max-age=31536000, immutable");
  } else if (request.method === "GET") {
    // Short cache with stale-while-revalidate for HTML pages
    res.headers.set("Cache-Control", "public, max-age=300, stale-while-revalidate=604800");
  } else {
    // Never cache form submissions
    res.headers.set("Cache-Control", "no-store");
  }
  
  return res;
};

// Bind site-wide for all reunion pages
export const config = {
  path: "/*",
};
