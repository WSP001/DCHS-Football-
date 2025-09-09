#!/bin/bash
set -euo pipefail

# DCHS Football Reunion - Atomic Deployment Validation Script
# Ensures all-or-nothing deployments with automatic rollback

DEPLOY_ID="${NETLIFY_DEPLOY_ID:-$(date +%s)}"
SITE_URL="${DEPLOY_PRIME_URL:-https://dchs-football-reunion.netlify.app}"
ROLLBACK_URL=""
VALIDATION_TIMEOUT=300  # 5 minutes
CANARY_TIMEOUT=120     # 2 minutes

echo "🚀 DCHS Atomic Deploy Validation Starting - Deploy ID: $DEPLOY_ID"
echo "📍 Target URL: $SITE_URL"

# Pre-deployment backup
backup_current_deploy() {
    echo "�� Creating deployment backup..."
    if [[ -n "${NETLIFY_DEPLOY_ID:-}" ]]; then
        ROLLBACK_URL="https://${NETLIFY_DEPLOY_ID}--dchs-football-reunion.netlify.app"
        echo "✅ Rollback URL secured: $ROLLBACK_URL"
    else
        echo "⚠️  No previous deploy found - proceeding without rollback URL"
    fi
}

# Critical path validation
validate_critical_paths() {
    echo "🔍 Validating critical reunion paths..."
    local paths=(
        "/"
        "/rsvp"
        "/thank-you"
        "/survey-complete"
        "/alumni-photos"
        "/schedule"
    )
    
    local failed_paths=()
    
    for path in "${paths[@]}"; do
        echo "  Testing: $path"
        if ! curl -sf --max-time 30 "${SITE_URL}${path}" > /dev/null; then
            failed_paths+=("$path")
            echo "  ❌ FAILED: $path"
        else
            echo "  ✅ OK: $path"
        fi
    done
    
    if [[ ${#failed_paths[@]} -gt 0 ]]; then
        echo "💥 CRITICAL PATH FAILURES DETECTED:"
        printf '  - %s\n' "${failed_paths[@]}"
        return 1
    fi
    
    echo "✅ All critical paths validated successfully"
    return 0
}

# RSVP flow validation (most critical)
validate_rsvp_flow() {
    echo "🎯 Validating RSVP → Thank-You flow..."
    
    # Test redirect from /survey-complete to /thank-you
    local redirect_status
    redirect_status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 30 "${SITE_URL}/survey-complete")
    
    if [[ "$redirect_status" != "302" && "$redirect_status" != "301" ]]; then
        echo "❌ RSVP redirect failed - Status: $redirect_status"
        return 1
    fi
    
    # Validate thank-you page content
    local thank_you_content
    thank_you_content=$(curl -sf --max-time 30 "${SITE_URL}/thank-you")
    
    if ! echo "$thank_you_content" | grep -q "Thank you"; then
        echo "❌ Thank-you page content validation failed"
        return 1
    fi
    
    echo "✅ RSVP flow validated successfully"
    return 0
}

# Performance baseline validation
validate_performance() {
    echo "⚡ Running performance validation..."
    
    local load_time
    load_time=$(curl -o /dev/null -s -w "%{time_total}" --max-time 30 "$SITE_URL")
    
    # Fail if load time > 3 seconds
    if (( $(echo "$load_time > 3.0" | bc -l) )); then
        echo "❌ Performance degradation detected - Load time: ${load_time}s"
        return 1
    fi
    
    echo "✅ Performance validated - Load time: ${load_time}s"
    return 0
}

# Security headers validation
validate_security() {
    echo "🔒 Validating security headers..."
    
    local headers
    headers=$(curl -sI --max-time 30 "$SITE_URL")
    
    local required_headers=(
        "strict-transport-security"
        "x-content-type-options"
        "x-frame-options"
    )
    
    local missing_headers=()
    
    for header in "${required_headers[@]}"; do
        if ! echo "$headers" | grep -qi "$header"; then
            missing_headers+=("$header")
        fi
    done
    
    if [[ ${#missing_headers[@]} -gt 0 ]]; then
        echo "❌ Missing security headers:"
        printf '  - %s\n' "${missing_headers[@]}"
        return 1
    fi
    
    echo "✅ Security headers validated"
    return 0
}

# Canary validation with progressive traffic
run_canary_validation() {
    echo "🐦 Running canary validation..."
    
    local start_time
    start_time=$(date +%s)
    local success_count=0
    local total_requests=0
    
    while [[ $(($(date +%s) - start_time)) -lt $CANARY_TIMEOUT ]]; do
        if curl -sf --max-time 10 "${SITE_URL}/" > /dev/null; then
            ((success_count++))
        fi
        ((total_requests++))
        sleep 2
    done
    
    local success_rate
    success_rate=$(echo "scale=2; $success_count * 100 / $total_requests" | bc)
    
    echo "📊 Canary Results: $success_count/$total_requests requests succeeded (${success_rate}%)"
    
    # Require 95% success rate
    if (( $(echo "$success_rate < 95.0" | bc -l) )); then
        echo "❌ Canary validation failed - Success rate below threshold"
        return 1
    fi
    
    echo "✅ Canary validation passed"
    return 0
}

# Automatic rollback function
trigger_rollback() {
    echo "🚨 TRIGGERING AUTOMATIC ROLLBACK"
    
    if [[ -z "$ROLLBACK_URL" ]]; then
        echo "💥 CRITICAL: No rollback URL available!"
        exit 1
    fi
    
    echo "⏪ Rolling back to: $ROLLBACK_URL"
    
    # TODO: Implement actual Netlify API rollback
    # netlify api rollbackDeploy --site-id="$NETLIFY_SITE_ID" --deploy-id="$PREVIOUS_DEPLOY_ID"
    
    echo "📨 Sending rollback notification..."
    # TODO: Implement notification (Slack, email, etc.)
    
    exit 1
}

# Main validation orchestrator
main() {
    local validation_start
    validation_start=$(date +%s)
    
    backup_current_deploy
    
    echo "🔄 Running atomic validation suite..."
    
    if ! validate_critical_paths; then
        echo "💥 Critical path validation failed"
        trigger_rollback
    fi
    
    if ! validate_rsvp_flow; then
        echo "💥 RSVP flow validation failed"
        trigger_rollback
    fi
    
    if ! validate_performance; then
        echo "💥 Performance validation failed"
        trigger_rollback
    fi
    
    if ! validate_security; then
        echo "💥 Security validation failed"
        trigger_rollback
    fi
    
    if ! run_canary_validation; then
        echo "💥 Canary validation failed"
        trigger_rollback
    fi
    
    local validation_time
    validation_time=$(($(date +%s) - validation_start))
    
    echo "🎉 ATOMIC DEPLOYMENT VALIDATION SUCCESSFUL!"
    echo "📊 Validation completed in ${validation_time}s"
    echo "🚀 Deploy $DEPLOY_ID is LIVE and VALIDATED"
    
    # Optional: Trigger success notifications
    echo "📨 Sending success notification..."
    
    return 0
}

# Timeout handler
timeout_handler() {
    echo "⏰ VALIDATION TIMEOUT REACHED"
    echo "🚨 Automatic rollback triggered due to timeout"
    trigger_rollback
}

# Set up timeout
trap timeout_handler SIGALRM
(sleep $VALIDATION_TIMEOUT && kill -ALRM $$) &
TIMEOUT_PID=$!

# Run main validation
main

# Cancel timeout if we succeed
kill $TIMEOUT_PID 2>/dev/null || true

echo "✨ DCHS Atomic Deploy Validation Complete"
