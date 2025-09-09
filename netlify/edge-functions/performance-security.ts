import type { Config, Context } from "@netlify/edge-functions";

export default async (request: Request, context: Context) => {
  const startTime = Date.now();
  const response = await context.next();
  
  // Enterprise security headers at network edge
  response.headers.set("Strict-Transport-Security", "max-age=63072000; includeSubDomains; preload");
  response.headers.set("X-Content-Type-Options", "nosniff");
  response.headers.set("X-Frame-Options", "SAMEORIGIN");
  response.headers.set("Referrer-Policy", "strict-origin-when-cross-origin");
  response.headers.set("Permissions-Policy", "camera=(), microphone=(), geolocation=()");
  response.headers.set("X-XSS-Protection", "1; mode=block");
  
  // Performance optimization for reunion assets
  const url = new URL(request.url);
  if (url.pathname.includes('/assets/') || url.pathname.includes('/alumni-photos/') || url.pathname.includes('.png') || url.pathname.includes('.jpg') || url.pathname.includes('.css') || url.pathname.includes('.js')) {
    response.headers.set("Cache-Control", "public, max-age=31536000, immutable");
  }
  
  // Special handling for thank-you pages (no caching)
  if (url.pathname.includes('/thank-you')) {
    response.headers.set("Cache-Control", "no-store, no-cache, must-revalidate");
    response.headers.set("Pragma", "no-cache");
  }
  
  // Real-time performance monitoring
  const processingTime = Date.now() - startTime;
  context.log(`Edge Function Performance: ${url.pathname} processed in ${processingTime}ms`);
  
  // Performance alert for autonomous optimization
  if (processingTime > 500) {
    context.log(`PERFORMANCE ALERT: Slow response detected (${processingTime}ms) for ${url.pathname}`);
  }
  
  // Add performance headers for monitoring
  response.headers.set("X-Edge-Processing-Time", `${processingTime}ms`);
  response.headers.set("X-DCHS-Edge-Optimized", "true");
  
  return response;
};

export const config: Config = {
  path: "/*",
  cache: "manual"
};
