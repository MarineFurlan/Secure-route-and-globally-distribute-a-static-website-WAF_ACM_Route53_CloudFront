#!/bin/bash

################################################################################
# Deployment validation tests
# Secure, route and globally distribute a static website
#
## End-to-end tests implicitly validate many components (DNS, CloudFront, ACM, S3).
################################################################################

set -e  # Exit on error (disabled for test execution)
set +e  # Re-enabled below to allow tests to fail individually

# Color codes for terminal output
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Test counters
PASSED=0
FAILED=0
TOTAL=0



################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

log_test(){
  echo -e "${YELLOW}TEST #$((TOTAL + 1)): $1${NC}"
  TOTAL=$((TOTAL + 1))
}

pass(){
  echo -e "${GREEN}✓ SUCCESS${NC}: $1"
  PASSED=$((PASSED + 1))
}

fail(){
  echo -e "${RED}✗ FAILED${NC}: $1"
  FAILED=$((FAILED + 1))
}


################################################################################
# Configuration
################################################################################

# Loading terraform variables
DOMAIN_NAME="$()"
CLOUDFRONT_DISTRIBUTION_ID="$()"
S3_BUCKET_NAME="$()"
BUCKET_REGION="$()"

################################################################################
# End-to-End Tests
# These tests implicitly validate: DNS, CloudFront deployment, ACM certificate,
# S3 bucket existence, bucket content, and basic connectivity
################################################################################

website_https_accessibility(){
  log_test "Website Accessibility via HTTPS"

  http_code=$(curl -s -o /dev/null -w "%{http_code}" "https://${DOMAIN_NAME}")

  if [ "$http_code" = "200" ]; then
    pass "Website accessible at https://${DOMAIN_NAME}"
    echo "✓ Implicitly validates: DNS resolution, CloudFront deployment, ACM certificate, S3 bucket & content"
    return 0
  else
    fail "Website returned HTTP $http_code (expected 200)"
    return 1
  fi
}

http_to_https_redirect(){
  log_test "HTTP to HTTPS Redirect"

  final_url=$(curl -s -o /dev/null -w "%{url_effective}" -L "http://${DOMAIN_NAME}")

  if [[ "$final_url" == https://* ]]; then
    pass "HTTP redirects to HTTPS (final: $final_url)"
    return 0
  else
    fail "HTTP does not redirects to HTTPS (final: $final_url)"
    return 1
  fi
}

################################################################################
# Security tests
# S3 Access blocked, WAF reactivity, TLS certificate validity
################################################################################

s3_direct_access_blocked(){
  log_test "Direct S3 Access Blocked"

  if[ -z "$S3_BUCKET_NAME"]; then
    echo "Skipped : S3_BUCKET_NAME not configured"
    TOTAL=$((TOTAL - 1))
    return 0
  fi

  s3_url=$(http://${S3_BUCKET_NAME}.s3-website-${BUCKET_REGION}.amazonaws.com)
  http_code=$(curl -s -o /dev/null -w %{http_code} "$s3_url" 2>/dev/null)

  if[ "$http_code" = "403"]; then
    pass "Direct S3 access is blocked (HTTP $http_code)"
    return 0
  else
    fail "Direct S3 access is NOT blocked (HTTP $http_code)"
    return 1
  fi

}

WAF_sql_injection_blocked(){
  log_test "WAF SQL Injection Protection"

  http_code=$(curl -s -o /dev/null -w %{http_code} "https://${DOMAIN_NAME}/?id=1")

  if[ "$http_code" = "403" ]; then
    pass "WAF protection is active"
    return 0
  elif [ "$http_code" = "200" ]
    fail "WAF does not block attacks"
    return 1
  else
    pass "Request blocked/not found - WAF or Application layer"
    return 0
  fi
}


tls_certificate_validity(){
  log_test "TLS Certificate Validation"


  # Get certificate expiration date
  cert_info=$(echo | openssl s_client -connect ${DOMAIN_NAME}:443 -servername ${DOMAIN_NAME} 2>/dev/null | \
                openssl x509 -noout -dates 2>/dev/null)

  if [ -z "$cert_info" ]; then
      fail "Could not retrieve SSL certificate information"
      return 1
  fi

  # Extract expiration date
    expiry_date=$(echo "$cert_info" | grep "notAfter" | cut -d= -f2)

  # Convert to timestamp and check if expires in more than 30 days

  expiry_timestamp=$(date -d "$expiry_date" +%s 2>/dev/null || date -j -f "%b %d %T %Y %Z" "$expiry_date" +%s 2>/dev/null)
    local current_timestamp
  current_timestamp=$(date +%s)
  days_until_expiry=$(( (expiry_timestamp - current_timestamp) / 86400 ))

  if[ $days_until_expiry -gt 30 ]; then
    pass "TLS certificate is valid"
    return 0
  elif [ $days_until_expiry -gt 0 ]; then
    pass "TLS certificate expires soon"
    return 0
  else
    fail "TLS certificate is expired"
    return 1
  fi
}


################################################################################
# Main Execution
################################################################################

main () {
  print_header "Infrastructure Integrity Tests"
  echo "Domain : $DOMAIN_NAME"
  echo "Bucket region : $BUCKET_REGION"
  echo "Test start time: $(date)"

  # === End-to-end tests === #
  print_header "End-to-end tests"
  website_https_accessibility
  http_to_https_redirect

  # === Security tests === #
  print_header "Security tests"
  s3_direct_access_blocked
  WAF_sql_injection_blocked
  tls_certificate_validity

  # === Summary ===
  print_header "Test Summary"
  echo "Test End Time: $(date)"
  echo ""
  echo "Total Tests:  $TOTAL"
  echo -e "${GREEN}Passed:       $PASSED${NC}"
  echo -e "${RED}Failed:       $FAILED${NC}"
}